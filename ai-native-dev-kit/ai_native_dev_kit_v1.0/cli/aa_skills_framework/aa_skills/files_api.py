"""
aa_skills.files_api
=====================

Thin wrapper around the Anthropic Files API for uploading local files
into a skill-execution container and downloading generated outputs.

Kept separate from client.py so file operations can be unit-tested/mocked
independently of the Messages API invocation logic.
"""

from __future__ import annotations

import os
from pathlib import Path
from typing import Optional


FILES_API_BETA = "files-api-2025-04-14"


def upload_file(client, path: str | Path) -> dict:
    """Upload a local file, return {file_id, filename, size_bytes}."""
    path = Path(path)
    if not path.exists():
        raise FileNotFoundError(f"Input file not found: {path}")
    with open(path, "rb") as f:
        uploaded = client.beta.files.upload(file=f, betas=[FILES_API_BETA])
    return {
        "file_id": uploaded.id,
        "filename": path.name,
        "size_bytes": path.stat().st_size,
    }


def extract_output_file_ids(response) -> list[dict]:
    """
    Walk a Messages API response and pull out every file_id produced by
    code execution, regardless of whether the skill ran through the
    bash or python execution sub-tool.
    """
    results = []
    for item in getattr(response, "content", []):
        item_type = getattr(item, "type", None)
        if item_type in ("bash_code_execution_tool_result", "code_execution_tool_result"):
            result = getattr(item, "content", None)
            result_type = getattr(result, "type", None)
            if result_type in ("bash_code_execution_result", "code_execution_result"):
                for f in getattr(result, "content", []) or []:
                    fid = getattr(f, "file_id", None)
                    if fid:
                        results.append({"file_id": fid})
    return results


def download_file(client, file_id: str, out_dir: str | Path) -> Path:
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    meta = client.beta.files.retrieve_metadata(file_id=file_id)
    content = client.beta.files.download(file_id=file_id)
    out_path = out_dir / meta.filename
    content.write_to_file(str(out_path))
    return out_path


def delete_file(client, file_id: str) -> None:
    client.beta.files.delete(file_id=file_id)

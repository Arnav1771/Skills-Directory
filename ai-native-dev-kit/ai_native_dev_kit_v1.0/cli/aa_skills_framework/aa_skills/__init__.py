"""
aa_skills
=========

Framework for invoking Aligned Automation (AA) AI-native Skills via the
Claude API, with file-based I/O and explicit context/window management
across chained skill invocations.

No claude.ai account is required — authentication is via API key only.
"""

from .registry import SkillRegistry, RegisteredSkill
from .context import SessionContext, GeneratedFile
from .client import AASkillInvoker
from .credits import CreditLedger, CreditStatus, verify_key_and_check_credits, set_initial_balance

__all__ = [
    "SkillRegistry",
    "RegisteredSkill",
    "SessionContext",
    "GeneratedFile",
    "AASkillInvoker",
    "CreditLedger",
    "CreditStatus",
    "verify_key_and_check_credits",
    "set_initial_balance",
]

__version__ = "0.1.0"

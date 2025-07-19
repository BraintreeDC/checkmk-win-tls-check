#!/usr/bin/env python3
"""Ruleset definition for Windows TLS plugin deployment"""

# (c) Andreas Doehler 'andreas.doehler@bechtle.com'
# License: GNU General Public License v2

from cmk.rulesets.v1 import Help, Label, Title
from cmk.rulesets.v1.form_specs import (
    BooleanChoice,
    DictElement,
    Dictionary,
)
from cmk.rulesets.v1.rule_specs import AgentConfig, Topic


def _valuespec_agent_config_win_tls_status():
    return Dictionary(
        title=Title("Windows TLS Status"),
        help_text=Help(
            "This will deploy the agent plugin <tt>win_tlsl_status.ps1</tt> "
            "to check the Windows TLS state."
        ),
        elements={
            "deploy": DictElement(
                parameter_form=BooleanChoice(
                    label=Label("Deploy plugin for Windows TLS"),
                ),
                required=True,
            )
        },
    )


rule_spec_agent_config_win_tls_status = AgentConfig(
    title=Title("Windows TLS Status"),
    topic=Topic.WINDOWS,
    name="win_tls_status",
    parameter_form=_valuespec_agent_config_win_tls_status,
)

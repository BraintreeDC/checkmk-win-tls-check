#!/usr/bin/env python3
"""Ruleset definition for Windows TLS status check"""

# (c) Andreas Doehler 'andreas.doehler@bechtle.com'
# License: GNU General Public License v2

from cmk.rulesets.v1 import Help, Label, Title
from cmk.rulesets.v1.form_specs import (
    DictElement,
    Dictionary,
    List,
    SingleChoice,
    SingleChoiceElement,
    String
)
from cmk.rulesets.v1.rule_specs import CheckParameters, HostCondition, Topic


def _parameter_valuespec_win_tls_status():
    return Dictionary(
        elements={
            "protocols": DictElement(
                parameter_form=List(
                    title=Title("TLS Protocol configuration"),
                    help_text=Help(
                        "Please select the appropriate protocol configuration."
                    ),
                    add_element_label=Label("Add protocol"),
                    remove_element_label=Label("Remove protocol"),
                    no_element_label=Label("No protocol selected"),
                    element_template=Dictionary(
                        elements={
                            "protocol": SingleChoice(
                                parameter_form=String(
                                    title=Title("Protocol"),
                                    elements=[
                                        SingleChoiceElement(
                                            name="TLS1_0",
                                            title=Title("TLSv1.0"),
                                        ),
                                        SingleChoiceElement(
                                            name="TLS1_1",
                                            title=Title("TLSv1.1"),
                                        ),
                                        SingleChoiceElement(
                                            name="TLS1_2",
                                            title=Title("TLSv1.2"),
                                        ),
                                        SingleChoiceElement(
                                            name="TLS1_3",
                                            title=Title("TLSv1.3"),
                                        ),
                                    ],
                                    help_text=Help("TLS protocol to monitor"),
                                ),
                            ),
                            "server": DictElement(
                                parameter_form=SingleChoice(
                                    title=Title("Server state"),
                                    help_text=Help("Expected state for server TLS"),
                                    elements=[
                                        SingleChoiceElement(
                                            name="0",
                                            title=Title("Disabled"),
                                        ),
                                        SingleChoiceElement(
                                            name="1",
                                            title=Title("Enabled"),
                                        ),
                                        SingleChoiceElement(
                                            name="ignore",
                                            title=Title("Ignore"),
                                        ),
                                    ],
                                )
                            ),
                            "client": DictElement(
                                parameter_form=SingleChoice(
                                    title=Title("Client state"),
                                    help_text=Help("Expected state for client TLS"),
                                    elements=[
                                        SingleChoiceElement(
                                            name="0",
                                            title=Title("Disabled"),
                                        ),
                                        SingleChoiceElement(
                                            name="1",
                                            title=Title("Enabled"),
                                        ),
                                        SingleChoiceElement(
                                            name="ignore",
                                            title=Title("Ignore"),
                                        ),
                                    ],
                                )
                            ),
                        }
                    ),
                )
            )
        }
    )


rule_spec_win_tls_status = CheckParameters(
    name="win_tls_status",
    title=Title("Windows TLS Status"),
    topic=Topic.OPERATING_SYSTEM,
    condition=HostCondition(),
    parameter_form=_parameter_valuespec_win_tls_status,
)

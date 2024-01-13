#!/usr/bin/env python3
# -*- encoding: utf-8; py-indent-offset: 4 -*-

# (c) Constantin Lotz <checkmk@constey.de>
# Used win_firewall_status as template for this from Andreas Doehler
# (c) Andreas Doehler <andreas.doehler@bechtle.com/andreas.doehler@gmail.com>

# This is free software;  you can redistribute it and/or modify it
# under the  terms of the  GNU General Public License  as published by
# the Free Software Foundation in version 2.  check_mk is  distributed
# in the hope that it will be useful, but WITHOUT ANY WARRANTY;  with-
# out even the implied warranty of  MERCHANTABILITY  or  FITNESS FOR A
# PARTICULAR PURPOSE. See the  GNU General Public License for more de-
# ails.  You should have  received  a copy of the  GNU  General Public
# License along with GNU Make; see the file  COPYING.  If  not,  write
# to the Free Software Foundation, Inc., 51 Franklin St,  Fifth Floor,
# Boston, MA 02110-1301 USA.

from cmk.gui.i18n import _
from cmk.gui.valuespec import (
    Dictionary,
    DropdownChoice,
    ListOf,
    Tuple,
    TextAscii,
)

from cmk.gui.plugins.wato.utils import (
    rulespec_registry,
    CheckParameterRulespecWithoutItem,
    RulespecGroupCheckParametersOperatingSystem,
)


def _parameter_valuespec_win_tls_status():
    return Dictionary(
        title=_('Configure the desired state for each TLS protocol.'),
        elements=[
            ("protocols",
             ListOf(
                 Tuple(elements=[
                     TextAscii(
                         title=_("Protocol name"),
                         help=_("Name of the TLS protocol."),
                     ),
                     DropdownChoice(
                         title=_("Client State"),
                         help=_("Default behaviour for the client tls state. 0 = Disabled, 1 = Enabled."),
                         choices=[
                             ("0", _("0")),
                             ("1", _("1")),
                             ("ignore", _("ignore")),
                         ],
                     ),
                     DropdownChoice(
                         title=_("Server State"),
                         help=_("Default behaviour for the server tls state. 0 = Disabled, 1 = Enabled."),
                         choices=[
                             ("0", _("0")),
                             ("1", _("1")),
                             ("ignore", _("ignore")),
                         ],
                     ),
                 ], ),
                 title=_("TLS Protocol configuration"),
                 help=_("Please select the abropriate protocol configuration."),
                 allow_empty=False,
                 default_value=[
                     ("TLS1_3", "ignore", "ignore"),
                     ("TLS1_2", "1", "1"),
                     ("TLS1_1", "0", "0"),
                     ("TLS1_0", "0", "0"),
                 ],
             )),
        ],
    )


rulespec_registry.register(
    CheckParameterRulespecWithoutItem(
        check_group_name="win_tls_status",
        group=RulespecGroupCheckParametersOperatingSystem,
        match_type="dict",
        parameter_valuespec=_parameter_valuespec_win_tls_status,
        title=lambda: _("Windows TLS Status"),
    ))

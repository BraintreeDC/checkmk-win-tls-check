#!/usr/bin/env python3
'''Windows TLS status check'''
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

# Example Output:

#<<<win_tls_status:sep(125)>>>
#Protocol|Server|Client
#TLS1_3|1|1
#TLS1_2|1|1
#TLS1_1|1|1
#TLS1_0|1|1

from typing import Any, Dict, Tuple
from cmk.base.plugins.agent_based.agent_based_api.v1.type_defs import (
    CheckResult,
    DiscoveryResult,
    StringTable,
)

from cmk.base.plugins.agent_based.agent_based_api.v1 import (
    register,
    Result,
    State,
    Service,
)

Section = Dict[str, Any]


def parse_win_tls_status(string_table: StringTable) -> Section:
    '''parse raw data into dictionary'''
    key = "Protocol"
    parsed = {}
    for i in string_table[1:]:
        element = dict(zip(string_table[0], i))
        parsed[element[key]] = element

    return parsed


register.agent_section(
    name="win_tls_status",
    parse_function=parse_win_tls_status,
)


def discovery_win_tls_status(section: Section) -> DiscoveryResult:
    '''if data is present discover service'''
    if section:
        yield Service()


def _get_params(params: Dict[str, Any], protocol) -> Tuple:
    for element in params.get("protocols", []):
        if not element:
            continue
        if element[0] == protocol:
            return element
    return (None, None, None)
    #return (None, None, None, None)


def check_win_tls_status(params: Dict[str, Any], section: Section) -> CheckResult:
    '''check the tls state compared to params'''
    for key, data in section.items():
        _protocol, server, client = _get_params(params, key)
        state = 0
        server_active = data.get("Server")
        client_active = data.get("Client")

        if (server != "ignore") and (server != server_active):
            state = max(state, 1)
            yield Result(
                state=State.WARN,
                summary=
                f"protocol {key} (server) is not as expected {server} vs. {server_active}")

        if (client != "ignore") and (client != client_active):
            state = max(state, 1)
            yield Result(
                state=State.WARN,
                summary=
                f"protocol {key} (client) is not as expected {client} vs. {client_active}")

        if (state == 0 or server == "ignore" or client == "ignore"):
            yield Result(state=State.OK, summary=f"protocol {key} as expected (S:{server_active}|C:{client_active})")


register.check_plugin(
    name="win_tls_status",
    service_name="Windows TLS Status",
    sections=["win_tls_status"],
    discovery_function=discovery_win_tls_status,
    check_function=check_win_tls_status,
    check_default_parameters={
        'protocols': [('TLS1_3', '1', '1'),
                     ('TLS1_2', '1', '1'),
                     ('TLS1_1', '0', '0'),
                     ('TLS1_0', '0', '0')]
    },
    check_ruleset_name="win_tls_status",
)

#   _                            
#  (_)                           
#   _  __ _ _ __   ___  _ __ ___ 
#  | |/ _` | '_ \ / _ \| '__/ _ \
#  | | (_| | | | | (_) | | |  __/
#  |_|\__, |_| |_|\___/|_|  \___|
#      __/ |                     
#     |___/                      

common_patterns = [
    "Filesystem",
    "Memory",
    "Process",
    "Number",
    "Systemd",
    "Temperature",
    "Site",
    "Kernel",
    "CPU",
    "Site cmk",
    "Disk IO",
    "Interface",
    "Mount",
    "OMD",
    "Process cmk",
    "TCP",
    "Uptime",
    "Postfix",
]

ignored_services = [
    {
        "id": "97f888b9-e1b8-4c94-9fa1-3be3d903dbd3",
        "value": True,
        "condition": {
            "service_description": [
                {"$regex": f"{pattern}.*"} for pattern in common_patterns
            ]
        },
        "options": {"disabled": False},
    },
] + ignored_services

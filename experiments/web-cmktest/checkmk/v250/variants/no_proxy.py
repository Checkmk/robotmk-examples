#   _ _
#  | (_)
#  | |_ _ __  _   ___  __
#  | | | '_ \| | | \ \/ /
#  | | | | | | |_| |>  <
#  |_|_|_| |_|\__,_/_/\_\


agent_config.setdefault("linux_robotmk", [])

agent_config["linux_robotmk"] = [
    {
        "id": "31facd61-7a05-4b97-8e2a-12133ae92ac2",
        "value": {
            "deployment": (
                "deploy",
                {
                    "suites_base_dir": "/usr/lib/check_mk_agent/robot",
                    "plan_groups": [
                        {
                            "execution_interval": 600.0,
                            "plans": [
                                (
                                    "manual_robot",
                                    {
                                        "application": "WebCondaOffline",
                                        "path_to_test_suite": "web-cmktest/suite.robot",
                                        "execution_config": {
                                            "timeout_per_attempt": 60.0,
                                            "rf_re_executions": (
                                                "no_re_executions",
                                                None,
                                            ),
                                        },
                                        "environment_config": (
                                            "conda",
                                            {
                                                "source": (
                                                    "archive",
                                                    "/usr/lib/check_mk_agent/robot/web-cmktest/web-cmktest.tar.gz",
                                                ),
                                                "build_timeout": 600.0,
                                            },
                                        ),
                                        "robot_framework_params": {
                                            "variables": [
                                                {"name": "HEADLESS", "value": "True"}
                                            ],
                                            "exit_on_failure": False,
                                        },
                                        "working_directory_cleanup": (
                                            "max_age",
                                            1209600.0,
                                        ),
                                    },
                                ),
                                (
                                    "manual_robot",
                                    {
                                        "application": "WebCondaOnline",
                                        "path_to_test_suite": "web-cmktest/suite.robot",
                                        "execution_config": {
                                            "timeout_per_attempt": 60.0,
                                            "rf_re_executions": (
                                                "no_re_executions",
                                                None,
                                            ),
                                        },
                                        "environment_config": (
                                            "conda",
                                            {
                                                "source": (
                                                    "manifest",
                                                    "web-cmktest/robotmk-env.yaml",
                                                ),
                                                "robotmk_manifest_path": "web-cmktest/robotmk-setup.yaml",
                                                "build_timeout": 600.0,
                                            },
                                        ),
                                        "robot_framework_params": {
                                            "variables": [
                                                {"name": "HEADLESS", "value": "True"}
                                            ],
                                            "exit_on_failure": False,
                                        },
                                        "working_directory_cleanup": (
                                            "max_age",
                                            1209600.0,
                                        ),
                                    },
                                ),
                                (
                                    "manual_robot",
                                    {
                                        "application": "WebRCCOnline",
                                        "path_to_test_suite": "web-cmktest/suite.robot",
                                        "execution_config": {
                                            "timeout_per_attempt": 60.0,
                                            "rf_re_executions": (
                                                "no_re_executions",
                                                None,
                                            ),
                                        },
                                        "environment_config": (
                                            "rcc",
                                            {
                                                "robot_yaml": "web-cmktest/robot.yaml",
                                                "build_timeout": 600.0,
                                                "dependency_handling": (
                                                    "internet_download",
                                                    None,
                                                ),
                                            },
                                        ),
                                        "robot_framework_params": {
                                            "variables": [
                                                {"name": "HEADLESS", "value": "True"}
                                            ],
                                            "exit_on_failure": False,
                                        },
                                        "working_directory_cleanup": (
                                            "max_age",
                                            1209600.0,
                                        ),
                                    },
                                ),
                            ],
                        }
                    ],
                    "rcc_configuration": {
                        "rcc_profile_config": ('default', None),
                        "robocorp_home_base": "/opt/robotmk/rcc_home/",
                    },
                    "conda_config": {
                        "base_directory": "/opt/robotmk/conda/",
                        "no_proxy": ["localhost", "127.0.0.1"],
                        "http_proxy": ("no_proxy", None),
                        "https_proxy": ("no_proxy", None),
                        "tls_certificate_validation": ("enabled", None),
                        "tls_revokation_enabled": True,
                    },
                },
            ),
            "cmk-match-type": "dict",
        },
        "condition": {},
        "options": {"disabled": False},
    },
] + agent_config["linux_robotmk"]
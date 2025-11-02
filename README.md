# 🧪 Robotmk Examples

Welcome to the **Robotmk Example Collection** — a curated set of example projects and templates for working with [Robotmk](https://robotmk.org) in [Checkmk Synthetic Monitoring](https://checkmk.com).  
This repository should help beginners with "helo world" examples as well as server advanced users serve as a source of inspiration with templates and experiments.

---

## Repository Content

### 1. Examples

All suites listed here are intended to be integrated with Checkmk using Robotmk for illustrative purposes.

**Web Tests:**

| Folder                                                                | Description                                                                                                            | Docs                                                                                                                                           |
| --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [web-mfa-login](examples/web/web-mfa-login)                           | This suite shows how easy it is to create own keywords with Python, here: calculating a TOTP token to log into an app. |                                                                                                                                                |
| [web-airbnb-responsive](examples/web/web-airbnb-responsive)           | A test which shows how to simulate mobile devices using different viewports like tablets and smartphones.              |                                                                                                                                                |
| [web-text](examples/web/web-text)                                     | How to test a web page for expected text.                                                                              | [Get Text](https://marketsquare.github.io/robotframework-browser/Browser.html#Get%20Text)                                                      |
| [web-images](examples/web/web-images)                                 | How to test a web page for an expected image.                                                                          | [Image Should Contain Template](https://manykarim.github.io/robotframework-doctestlibrary/VisualTest.html#Image%20Should%20Contain%20Template) |
| [supermarket-complaints](examples/web/supermarket-complaints)         | Test for the supermarket complaints portal, see Youtube Channel =>                                                     | [Checkmk Synthetic Monitoring Series (Youtube)](https://www.youtube.com/playlist?list=PL8DfRO2DvOK2XZVvaZwUztchXWoOYfnDM) |

**Robot Framework**-only:

| Folder                                                                           | Description                                                                       | Docs                                                                                                           |
| -------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| [rf-python-varfiles](examples/rf/rf-python-varfiles)                             | WIP: A playground to test with variable files (TBD: YAML)                         | [Variable Files](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#variable-files) |
| [rf-listener-create-dynamic-tests](examples/rf/rf-listener_create_dynamic_tests) | Shows how to use a Robot Framework listener to generate test cases on runtime.    | [Listener API](https://docs.robotframework.org/docs/extending_robot_framework/listeners_prerun_api/listeners)  |
| [rf-keyword-grouping](examples/rf/rf-keyword-grouping)                           | An exmaple of how to use the new `GROUP` syntax introduced in Robot Framework 7.2 | [GROUP Syntax](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#group-syntax)     |
| [rf-custom-library](examples/rf/rf-custom-library)                               | How to write your own RF keywords in Python                                       | [Creating Keywords](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#creating-keywords)    |

**Others**:

| Folder                                                                           | Description                                                                                                            | Docs                                                                                                           |
| -------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| [api/github-api](./examples/api/github-api/)                                     | This suite demonstrates how to use the Requests Library to connect with REST APIs.                                     | [Requests Library](https://docs.robotframework.org/docs/different_libraries/requests)                          |
| [robotcode-toml](examples/robotcode-toml)                                        | WIP: A repository to showcase the features of the awesome RobotCode extension                                          | [RobotCode TOML](https://robotcode.io/03_reference/config)                                                     |
| [web-tables](examples/web/web-tables)                                 | A small test which does some tricks with HTML tables.                                                                  | [Tables](https://marketsquare.github.io/robotframework-browser/Browser.html#Get%20Table%20Cell%20Element)                                      |

---

### 2. [`templates/`](./templates)

| Folder                        | Description                                                | Docs |
| ----------------------------- | ---------------------------------------------------------- | ---- |
| [Minimal](templates/minimal)  | Very minimal set of files to start with RF                 |      |
| [Web Template](templates/web) | Minimal set of files to start with RF and Browser Library. |      |

---

### 3. Experiments/Minimal examples

| Folder                                                    | Description                                                                                                          | Docs                                                                                              |
| --------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| [cmk-kpi-monitoring](./examples/cmk-kpi-monitoring)       | A RF suite showing how specific keywords can be discovered, alternatively to the server-side pattern based approach  | [Checkmk Docs: KPI Monitoring](https://docs.checkmk.com/latest/de/robotmk.html#kpi)               |
| [dummy_globetrack_tests](examples/dummy_globetrack_tests) | "Globetrack" is my fake application and I use this whenever I need a handful of realistic tests with runtime graphs. | --                                                                                                |
| [rf-simple-examples](examples/rf/rf-simple-examples)      | It really can't be any simpler.                                                                                      | --                                                                                                |
| [rf-strings](examples/rf/rf-strings)                      | How to work with the Strings Library.                                                                                | [String Library](https://robotframework.org/robotframework/latest/libraries/String.html)          |
| [robotcode-toml](examples/robotcode-toml)                 | Sample TOML files for RobotCode(for inspiration)                                                                     | [RobotCode: About TOML FIles](https://robotcode.io/02_get_started/configuration#about-toml-files) |
| [web_playwright_traceviewer](examples/web/web_playwright_traceviewer) | A Playwright based test to demonstrate how traces, HAR files and videos can be recorded.                               | [desc](https://marketsquare.github.io/robotframework-browser/Browser.html#New%20Context)                                                       |
| [web-checkmk-site](examples/web/web-checkmk-site)                     | WIP: This test logs into a Checkmk site and verifies the users.                                                        |                                                                                                                                                |
|                                                           |                                                                                                                      |                                                                                                   |

---

## 📚 Learn More

- [Checkmk Training on Synthetic Monitoring](https://checkmk.com/trainings/classes) - Learn from the inventor of Robotmk!
- [Checkmk Documentation – Synthetic Monitoring](https://docs.checkmk.com/)
- [Robot Framework Official Docs](https://robotframework.org/)
- [Robotmk Blog](https://blog.robotmk.org)

---

## 💬 Contributing & Feedback

Found a bug? Have an idea or want to contribute your own test example?  
Feel free to open an issue or pull request. This project thrives on shared experience.

---

## 📝 License

MIT License — see [`LICENSE`](./LICENSE)

---

Thanks for checking out this collection. Happy testing and monitoring!  

**Simon Meggle / Checkmk**

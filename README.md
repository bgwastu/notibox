<div align="center">
  <img width="80px" src="assets/logo/logo_light.svg">
  <h1>Notibox</h1>
  <p>Simple app to store quick notes efficiently in Notion. Built with Flutter.</p>
</div>

<div align="center">
<a href="#">
  <img width="150px" src="https://camo.githubusercontent.com/312337bc4c1fbc3fb62ec751bddfc5b61b8d0819c8e266c63ea35cd344f879ca/68747470733a2f2f6769746a6f75726e616c2e696f2f696d616765732f616e64726f69642d73746f72652d62616467652e706e67">
</a>
</div>
<br>
<div align="center">
  <a href="https://github.com/atticdev/notibox/issues"><img alt="GitHub issues" src="https://img.shields.io/github/issues/atticdev/notibox"></a>
  <a href="https://codemagic.io/apps/60f521280c5097fa1bfce8d5/60fbe739be21229f0a9ce310/latest_build"><img alt="Codemagic" src="https://api.codemagic.io/apps/60f521280c5097fa1bfce8d5/60fbe739be21229f0a9ce310/status_badge.svg"></a>
  <a href="https://github.com/atticdev/notibox/releases"><img alt="GitHub release (latest by date including pre-releases)" src="https://img.shields.io/github/v/release/atticdev/notibox?include_prereleases"></a>

  <a href=""><img alt="GitHub" src="https://img.shields.io/github/license/atticdev/notibox"></a>
</div>

<br>

# Description
Notibox is an inbox application that integrates with Notion. Used to save your quick notes more quickly and efficiently. Notibox uses the [Notion API](https://developers.notion.com/) to work.

# Screenshots
<table >
  <tr>
    <td><img src="screenshots/0.png" width="441"/></td>
    <td><img src="screenshots/1.png" width="441"/></td>
    <td><img src="screenshots/2.png" width="441" /></td>
  </tr>
  <tr>
    <td><img src="screenshots/3.png" width="441"/></td>
    <td><img src="screenshots/4.png" width="441"/></td>
  </tr>
</table>

## Download

You can either download from [Play Store](#) or download the application from [Codemagic](https://codemagic.io/apps/60f521280c5097fa1bfce8d5/60fbe739be21229f0a9ce310/latest_build) by downloading **app-release.apk**.


# Features
- Offline, all notes will be available even when there is no network
- Reminder
- Inbox search feature
- Bidirectional sync
- Customizable label
- Many more!

# How to contribute
Any contribution are really appreciated. Here are some points where you can contribute to Notibox.
- Helping to create unit or widget tests (please do, I don't know how to do test properly)
- Report some bug 🪲
- Give us suggestions
- Add new functionality (please open an issue first to discuss what you would like to add)

## Localization
For localization, this app is only support in English, and soon in other language. If you are willing to add this feature, don't hesitate to make a PR.

##  Architecture
Notibox using GetX as state management, the structure itself is using directory by feature. It's still messy, feel free to open issues or PRs if you have any suggestions on the code.

## Getting Started
- Clone this package
- Get dependencies with `flutter pub get`
- Add Firebase `google-services.json` to `android/app`
- Run the app with `flutter run`

# License
Distributed under the Apache 2.0 License. See [LICENSE](/LICENSE) for more information.

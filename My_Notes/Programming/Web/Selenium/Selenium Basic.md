# Selenium Basic

## Abstract

先引用[Tutorialpoints](https://www.tutorialspoint.com/selenium/selenium_overview.htm)的介紹

> Selenium is an open-source and a portable automated software testing tool for testing web applications. It has capabilities to operate across different browsers and operating systems. Selenium is not just a single tool but a set of tools that helps testers to automate web-based applications more efficiently.

| Sr.No. |                      Tool & Description                      |
| :----: | :----------------------------------------------------------: |
|   1    | **Selenium IDE** Selenium **I**ntegrated **D**evelopment **E**nvironment (IDE) is a Firefox plugin that lets testers to record their actions as they follow the workflow that they need to test. |
|   2    | **Selenium RC** Selenium **R**emote **C**ontrol (RC) was the flagship testing framework that allowed more than simple browser actions and linear execution. It makes use of the full power of programming languages such as Java, C#, PHP, Python, Ruby and PERL to create more complex tests. |
|   3    | **Selenium WebDriver** Selenium WebDriver is the successor to Selenium RC which sends commands directly to the browser and retrieves results. |
|   4    | **Selenium Grid** Selenium Grid is a tool used to run parallel tests across different machines and different browsers simultaneously which results in minimized execution time. |

## Download and Installation

### Selenium IDE

首先可以試試 Selenium IDE ，一般來說它是一個browser extension 我這邊使用 chrome 的。直接在商店就找的到了。

這東西簡單來說就是可以錄製使用者在瀏覽器的操作，然後回放。

但也就僅此而已，更複雜的操作還是需要透過coding完成。

因為沒啥難度，所以筆記中不太會特別紀錄這個部分。



### Web Driver

接著需要 Webdriver 這便要依據瀏覽器來找到對應的driver

這邊一樣先使用chrome

首先確認chrome版本，點右上角的`...` >>`說明`>>`關於CHROME`，就能看到目前的瀏覽起版本

![](https://i.imgur.com/3DZZtRs.png)

然後去找對應的driver

稍微找了一下，看到[這個網站](https://chromedriver.chromium.org/)的driver版本是最新的，不過還是比瀏覽器的版本慢了一點點，總之先用**98.0.4758.80**試試看了
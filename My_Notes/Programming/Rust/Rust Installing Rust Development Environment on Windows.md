# Installing Rust Development Environment on Windows

tags: #rust #environment

This guide provides step-by-step instructions to help you install the Rust development environment on a Windows computer.

## 1. Download the Rust Installer

- Visit the official Rust website: [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install).
- Click on the **"Download for Windows"** button to download the `rustup-init.exe` file.

## 2. Run the Installer

- Double-click the downloaded `rustup-init.exe` file.
- A Command Prompt window will open with installation options:
  - Press **Enter** to choose the **default installation** (recommended).
  - Or enter the appropriate option number for a **custom installation**.

## 3. Complete the Installation

- The installer will download and configure the necessary components:
  - **Rust Compiler** (`rustc`)
  - **Package Manager** (`cargo`)
  - **Rust Standard Library**
- Once the installation is complete, close the Command Prompt window.

## 4. Configure Environment Variables (If Necessary)

- The installer usually adds Rust to your system's `PATH` environment variable automatically.
- If not, you may need to add Rust's installation path manually:
  - Right-click on **This PC** > **Properties** > **Advanced system settings** > **Environment Variables**.
  - Under **System variables**, select **Path** and click **Edit**.
  - Click **New** and add the path to Rust's `bin` directory (e.g., `C:\Users\YourUsername\.cargo\bin`).

## 5. Verify the Installation

- Open a new Command Prompt window.
- Run `rustc --version` to check the Rust compiler version.
- Run `cargo --version` to check the Cargo package manager version.
- If both commands display version information, Rust is installed correctly.

## 6. Install C++ Build Tools (If Required)

Some Rust crates require compiling native code, which depends on C++ build tools.

- Download **Visual Studio Build Tools**:
  - Visit [https://visualstudio.microsoft.com/downloads/](https://visualstudio.microsoft.com/downloads/).
  - Scroll down to **"Tools for Visual Studio"** and click on **"Build Tools for Visual Studio"**.
- Install the **C++ Build Tools**:
  - Run the downloaded installer.
  - In the installer, select the **"Desktop development with C++"** workload.
  - Click **Install** and wait for the installation to complete.

## 7. Update Rust (Optional)

- To update Rust to the latest version, run:
  ```shell
  rustup update
  ```

## 8. Create and Run a New Rust Project

- Use Cargo to create a new project:
  ```shell
  cargo new hello_world
  cd hello_world
  ```
- Build and run the project:
  ```shell
  cargo run
  ```
- You should see the output:
  ```
  Hello, world!
  ```

## 9. Choose a Code Editor

Enhance your development experience with a code editor that supports Rust.

- **Visual Studio Code**:
  - Install [Visual Studio Code](https://code.visualstudio.com/).
  - Add the [Rust extension](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust) for syntax highlighting and code completion.
- **IntelliJ IDEA**:
  - Install [IntelliJ IDEA](https://www.jetbrains.com/idea/).
  - Add the [Rust plugin](https://intellij-rust.github.io/).
- **CLion**:
  - Install [CLion](https://www.jetbrains.com/clion/), which has built-in Rust support (may require a subscription).

## Additional Resources

- **Learning Rust**:
  - Official Rust Book: [https://doc.rust-lang.org/book/](https://doc.rust-lang.org/book/)
  - Rust By Example: [https://doc.rust-lang.org/rust-by-example/](https://doc.rust-lang.org/rust-by-example/)
- **Community Support**:
  - Rust Users Forum: [https://users.rust-lang.org/](https://users.rust-lang.org/)
  - Rust Discord Community: [https://discord.gg/rust-lang](https://discord.gg/rust-lang)

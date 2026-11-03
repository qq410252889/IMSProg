## IMSProg

<img align="right" src="img/mini_logo_IMSProg.svg">

* [系统软件要求](#系统软件要求)
* [使用方法](#使用方法)
* [支持的芯片列表](#支持的芯片列表)
* [软件包](#软件包)
* [更新日志](ChangeLog)
* [项目结构](#项目结构)
* [芯片数据库格式](#芯片数据库格式)
* [许可证](#许可证)
* [翻译](#翻译)

**IMSProg** — **I**2C（**I**平方C）、**M**icroWire（微线）和 **S**PI 的 EEPROM/Flash 芯片 **Prog**rammer（编程器）— 用于读写 EEPROM 芯片的程序，支持
`CH341A 编程器`、`CH347T 编程器` 和 `FT232H v1.2 编程器`设备。

| CH341A/B v1.2 | CH341A v1.7 | CH347T v1.0 | CH347T v1.1 | FT232H v1.2 |
| :---:         | :---:       | :---:       | :---:       | :---:       |
| ![CH341A black](img/ch341_black150.png)  ![CH341A green](img/ch341_green150.png) | ![CH341A green](img/ch341v1_7.png) |![CH347T v1.0](img/ch347_150.png) |![CH347T v1.1](img/ch347_v1_1_150.png) |![CH347T v1.1](img/ft232h_150.png) |

IMSProg 致敬了 [QHexEdit2](https://github.com/Simsys/qhexedit2) 十六进制编辑器
和 [SNANDer 编程器](https://github.com/McMCCRU/SNANDer)。芯片数据库的格式基于
EZP2019、EZP2020、EZP2023、Minpro I、XP866+ 编程器所用格式。注意，格式并不完全相同！

IMSProg 是一套工具集合：

1. IMSProg —— 芯片编程器（主程序）。

2. IMSProg_editor —— 芯片数据库编辑器。

3. IMSProg_database_update —— 通过外部 Web 服务器更新芯片数据库。

![CH341A EEPROM programmer](img/IMSProg_1.png)

![CH341A EEPROM programmer](img/IMSProg.png)

## 编译项目
```
git clone https://github.com/bigbigmdm/IMSProg.git && cd IMSProg
sudo ./build_all.sh
```

## 系统软件要求

### Linux

编译需要：
- g++ 或 clang
- CMake
- libusb 1.0
- libftdi
- Qt5 或 Qt6
- Qt5LinguistTools 或 Qt6LinguistTools
- pkgconf 或 pkg-config
- udev

在 Debian 及其衍生发行版上：

- 使用 Qt5：

`sudo apt-get install cmake g++ libusb-1.0-0-dev qtbase5-dev qttools5-dev pkgconf libftdi1-dev`

- 使用 Qt6：

`sudo apt-get install cmake g++ libusb-1.0-0-dev pkgconf qt6-base-dev 
qt6-tools-dev libftdi1-dev linguist-qt6 qt6-l10n-tools qt6-base-dev-tools 
qt6-tools-dev-tools`

在 Debian >=13 和 Ubuntu >=24.04 上：

`sudo apt-get install systemd-dev`

在更老的版本上：

`sudo apt-get install udev`

:information_source: Debian < 11 和 Ubuntu < 20.04 不受支持，你可能无法在这些系统上正常使用。

在 Fedora 及其衍生发行版上：

- 使用 Qt5：

```
sudo dnf install cmake libusb libusb1 libusb1-devel qt5-qtbase-devel
sudo dnf install pkgconf-pkg-config qt5-linguist libftdi-devel
```

- 使用 Qt6：

```
sudo dnf install cmake gcc-c++ libusb1-devel pkgconf-pkg-config qt6-qtbase-devel
sudo dnf install qt6-qttools-devel qt6-linguist libftdi-devel
```

在 OpenSUSE 及其衍生发行版上：

- 使用 Qt5：

```
sudo zypper install cmake gcc-c++ libqt5-qtbase-devel
sudo zypper install libqt5-linguist-devel libusb-1_0-devel
sudo zypper install libftdi1-devel
```

- 使用 Qt6：

```
sudo zypper install cmake gcc-c++ libqt6-qtbase-devel
sudo zypper install libqt6-linguist-devel libusb-1_0-devel
sudo zypper install libftdi1-devel
```

### macOS
如果使用 Homebrew，Xcode 命令行工具（Command Line Tools）会默认安装；如果没有安装，请在终端手动安装：

```
xcode-select --install
```

安装所需软件包

使用 brew：

```
brew install qt@6 libusb cmake pkgconf libftdi
```

如果没有使用 [build_all.sh](build_all.sh) 脚本，请确保 `libusb` 已加入你的 `C_INCLUDE_PATH` 环境变量：

```
export C_INCLUDE_PATH=/usr/local/opt/libusb/include
```

## 使用方法：

注意：在 macOS 上，键盘快捷键请用 CMD `⌘` 代替 CTRL。

## 芯片编程器

### 启动
可以在终端运行以下命令启动：
```
$ IMSProg
```

### 连接
- 将芯片插入 CH341A 编程器对应插槽。`24xxx` 和 `25xxx` 系列芯片必须按照 CH341A 编程器 PCB 上的标记直接插入。`93xxx` 系列芯片必须插入 `93xxx 转接座`，再将转接座插入标有 `25xxx` 的编程器插槽。DataFlash `AT45DBxxx` 系列芯片必须安装在 `SOP-8 DIP-8` 转接座上，再将该转接座插入 `45xxx` 转接座。`45xxx` 转接座必须安装在标有 `25xxx` 的编程器插槽中。SPI NAND Flash 芯片必须安装在 `WSON-8 DIP-8` 转接座中，该转接座必须安装在标有 `25xxx` 的编程器插槽中。

> [!NOTE]
> *在当前版本中，CH347 编程设备不支持 MicroWire（93Cxx）协议。*
>
> *CH347T V1.1 是比 CH347T V1.0 速度更低的设备。*

![Adapter](img/93xxx_adapter.png)

- 如果芯片供电电压为 1.8 伏，则必须插入 `1.8 伏转接座`，再将转接座插入所需的编程器插槽。

![Adapter](img/1_8_adapter.png)

- 将 CH341A 编程器插入电脑的 USB 接口并运行 `IMSProg`。
- 只要没有进行基本操作（读取、校验、编程），你可以随时将编程器（CH341A）从 USB 接口拔出或插入。
- 更多转接座信息请参阅
[此处](https://github.com/bigbigmdm/Tools_for_CH341A_programmer?tab=readme-ov-file#Homemade-Chip-adapters)。

### 芯片类型选择
从 `Type`（类型）下拉菜单中选择所用芯片的类型：使用 `25xxx` 系列 SPI NOR FLASH 芯片时选 `SPI_FLASH`，使用 SPI NAND FLASH 芯片时选 `SPI_NAND`，使用 `24xxx` 系列 I2C EEPROM 时选 `24_EEPROM`，使用 `93xxx` 系列 MicroWire EEPROM 时选 `93_EEPROM`，使用 DataFlash 芯片 `AT45DBxxx` 系列时选 `45_EEPROM`。
当使用 `25xxx` 系列 SPI NOR FLASH 芯片（菜单项 `type` -> `SPI_FLASH`）、或 SPI NAND FLASH 芯片（菜单项 `type` -> `SPI_NAND`）、或 `AT45DBxx` 系列 SPI FLASH（菜单项 `type` -> `45_EEPROM`）时，`Detect`（检测）按钮可用。按下 `Detect` 按钮或 ![Detect](img/test64.png) 或 `<Ctrl+D>` 时，会从芯片读取 JEDEC 信息，并从芯片数据库加载该芯片的所有参数。任何参数（`size` 容量、`page size` 页大小、`block size` 块大小、`VCC voltage` 电压、`and 4-bit address length` 4 位地址长度）都可以手动修改。你可以手动输入 `Manufacture`（厂商）和 `Name`（名称）下拉菜单数据——其他所有参数将自动从芯片数据库加载。
当使用 `24xxx`、`93xxx`、`95xxx` 或 `25xxx` SPI EEPROM（非 NOR FLASH）系列芯片时，需要手动输入 `Manufacture`（厂商）和 `Name`（名称）下拉菜单数据——其他所有参数将自动从芯片数据库加载。

### 文件操作
- ![Save](img/save64.png) 或 `<Ctrl+S>` 按钮用于将电脑缓冲区保存为文件。

- ![Open](img/open64.png) 或 `<Ctrl+O>` 按钮用于将文件载入电脑缓冲区。

- ![SavePart](img/saveBlock64.png) 或 `<Ctrl+Shift-S>` 按钮用于将电脑缓冲区的一部分保存为文件（需要输入起始地址和长度）。该操作可用于将二进制数据镜像拆分成多部分。

- ![LoadPart](img/loadBlock64.png) 或 `<Ctrl+Shift-S>` 按钮用于将小文件加载到缓冲区中的指定地址。缓冲区中的数据片段将被文件中的新数据替换。

- ![Edit](img/chipEdit64.png) 或 `<Ctrl+Q>` 按钮用于调用芯片数据库编辑器。

- 菜单项 `File / Import from Intel HEX`（文件/从 Intel HEX 导入）用于将 Intel HEX 文件载入电脑缓冲区。

- 菜单项 `File / Export to Intel HEX`（文件/导出为 Intel HEX）用于将电脑缓冲区保存为 Intel HEX 格式文件。

### 基本编程器操作
- 按 `Read`（读取）或 ![Read](img/read64.png) 或 `<Ctrl+R>` 将数据从芯片读入电脑缓冲区。

- 按 ![Write](img/write64.png) 或 `<Ctrl+W>` 将数据从电脑缓冲区写入芯片。

- 按 ![Erase](img/erase64.png) 或 `<Ctrl+E>` 将擦除芯片中的所有数据。

- 选择 `主菜单 -> Chip -> Check erase`（芯片/检查擦除）或按 `<Ctrl+J>`，可以检查芯片中的数据是否已被全部正确删除。

- 按 ![Verify](img/verify64.png) 或 `<Ctrl+T>` 按钮比较芯片中的数据与电脑缓冲区中的数据。

进度条显示读取、擦除和校验操作的进度。

- `Auto`（自动）按钮用于按顺序执行擦除、检查擦除、写入和校验操作。如果其中某项操作不需要，可以取消勾选该操作对应的复选框。

- ![Stop](img/stop64.png) 或 `<Ctrl+I>` 键用于强制中断芯片读写/擦除/校验操作。

- `i` 键显示芯片与 CH341A 设备的连接图。
- `主菜单 -> Chip -> Chip info`（芯片/芯片信息）或 `<Ctrl+P>` 项显示 SPI NOR 闪存芯片的 Serial Flash Discoverable Parameter（SFDP）寄存器和状态寄存器。

![SFDP](img/sfdp_unblock_en.png)

如果 SPI NOR FLASH 芯片能被正常检测，但无法读取（提示 `Error reading sector 0` 错误），可以在 `Chip info`（芯片信息）窗口中将 `BP4` 和 `BP3` 位改为 0，然后按 `Write registers`（写入寄存器）按钮。之后重新执行芯片读取操作。

![SFDP](img/sfdp_unblock_en2.png)

如果 SPI NOR FLASH 芯片读取不可靠（每次校验和都不同），且芯片有 `Status Register 2`（状态寄存器 2），可以将 `DRV0` 和 `DRV1` 位改为 0，然后按 Write Registers（写入寄存器）按钮。这会提高芯片 `DO` 引脚输出级的驱动能力。之后重新执行芯片读取操作。

对于只有一个状态寄存器的 `25xxx`、`95xxx` 和 `45xxx` 系列芯片，`Chip info`（芯片信息）窗口如下：

![SFDP](img/sr0_en.png)

对于 `SPI NAND FLASH` 芯片，`Chip info`（芯片信息）窗口如下：

![SFDP](img/sr_nand_en.png)

- `主菜单 -> Chip -> Security Registers`（芯片/安全寄存器）或 `<Ctrl+U>` 项用于操作 `SPI NOR Flash` 和 `SPI NAND FLASH` 的安全寄存器数据。该窗口支持从电脑读取、写入、擦除、保存和加载安全寄存器数据。

![Security registers](img/Security_registers_form.png)

窗口底部的按钮（![Read](img/read64.png)、![Erase](img/erase64.png)、![Write](img/write64.png)、![Open](img/open64.png)、![Save](img/save64.png)）功能与主窗口顶部的按钮类似。`Security register number:`（安全寄存器编号：）下拉菜单允许你为当前芯片选择一个有效寄存器进行操作。安全寄存器可以被永久锁定为只读（禁止写入）。如果想了解这一点，请查看 `主菜单 -> Chip -> Chip Information`（芯片/芯片信息）项或 `<Ctrl+P>`，在 `Status register 1`（状态寄存器 1）中的 `LB3`、`LB2` 和 `LB1` 数据字段。详细信息请参阅芯片的数据手册。
对于 NAND FLASH 芯片，你可以扫描坏块，使用
`主菜单 -> Chip -> Bad block management`（芯片/坏块管理）或 `<Ctrl+B>` 键。

![Bad block scan](img/bbm_chip_scan_en.png)

对于这些芯片，你也可以在此菜单中更改擦除和写入参数。

![Bad block scan](img/bbm_settings_en.png)

> [!NOTE]
> *在此版本的 IMSProg 中，对 NAND Flash 芯片执行 `Verify`（校验）和 `Check erase`（检查擦除）功能时不会跳过坏块。如果你的芯片包含坏块，请不要使用这些功能。*

### 缓冲区（十六进制编辑器）操作
十六进制芯片编辑器（屏幕右侧）用于显示和修改缓冲区数据。

它包含以下控件：![Undo](img/undo64.png) 撤销、![Redo](img/redo64.png) 重做，以及 ![Search](img/hexsearch64.png) 查找/替换。`[Ctrl+A]` 键用于更新 CRC24 校验和。`[Ctrl+G]` 键用于将光标移动到输入的地址。`[Ctrl+L]` 键用于用特殊测试数组填充十六进制编辑器缓冲区。`[Ctrl+K]` 键用于用用户代码填充十六进制编辑器缓冲区。`[Ctrl+M]` 键用于比较最近一次和上一次芯片读取或文件打开操作的结果。

![compare](img/compare_files_en.png)

### 编程器类型
`主菜单 -> Programmer`（编程器）项用于更改编程器类型。

### 快捷键列表：

| 快捷键   | 功能                                     |
| :---     | :---                                     |
| Ctrl+A   | 计算校验和                               |
| Ctrl+B   | NAND 芯片坏块管理                        |
| Ctrl+C   | 复制选中字节（十六进制编辑器）           |
| Ctrl+D   | 检测芯片                                 |
| Ctrl+E   | 擦除芯片                                 |
| Ctrl+F   | 查找/替换（十六进制编辑器）              |
| Ctrl+G   | 转到地址（十六进制编辑器）               |
| Ctrl+H   | 关于 IMSProg                             |
| Ctrl+I   | 强制停止芯片操作                         |
| Ctrl+J   | 检查芯片擦除                             |
| Ctrl+K   | 填充用户代码（十六进制编辑器）           |
| Ctrl+L   | 填充测试数组（十六进制编辑器）           |
| Ctrl+M   | 比较文件（十六进制编辑器）               |
| Ctrl+N   | 编辑芯片数据库                           |
| Ctrl+O   | 打开文件                                 |
| Ctrl+P   | 芯片信息（SFDP + 状态寄存器）            |
| Ctrl+Q   | 退出                                     |
| Ctrl+R   | 读取芯片                                 |
| Ctrl+S   | 保存文件                                 |
| Ctrl+T   | 校验芯片                                 |
| Ctrl+U   | 安全寄存器                               |
| Ctrl+V   | 粘贴选中字节（十六进制编辑器）           |
| Ctrl+W   | 写入芯片                                 |
| Ctrl+X   | 退出                                     |
| Ctrl+Y   | 重做（十六进制编辑器）                   |
| Ctrl+Z   | 撤销（十六进制编辑器）                   |

## 芯片数据库编辑器

![Chip editor](img/chip_editor_eng.png)

芯片数据库编辑器 —— IMSProg_editor 是一个独立程序，可以从 `Development`（开发）菜单或从 IMSProg 程序中点击 ![Edit](img/chipEdit64.png) 启动。

只有加载了扩展名为 .Dat 的芯片数据库文件后，编辑器中的所有操作才可用。

`File`（文件）菜单。

- `Open`（打开）或 `[Ctrl+O]` 或 ![open](img/open.png) 用于加载数据文件。
- `Save`（保存）或 `[Ctrl+S]` 或 ![save](img/save.png) 将芯片参数表保存为数据库文件。
- `Exit`（退出）或 `[Ctrl+X]` 或 ![exit](img/exit.png) —— 退出编辑器。
- `Export to CSV format`（导出为 CSV 格式）或 `[Ctrl+X]` 或 ![export](img/tocsv.png) 允许将芯片数据以 CSV 格式导出，供电子表格软件进一步处理 —— LibreOffice Calc、OpenOffice Calc、Google 表格等。
- `Import from CSV file`（从 CSV 文件导入）或 `[Ctrl+Shift+X]` 或 ![import](img/import.png) —— 加载 CSV 格式的表格，并将其数据添加到表中已有数据中。

`Edit`（编辑）菜单。

- `Delete Rows`（删除行）或 `Del` 或 ![delete](img/del.png) —— 删除一行或多行。
- `Add Row`（添加行）或 `Ins` 或 ![add](img/plus.png) —— 在选中行下方添加一行，并将选中行的所有数据复制到新行。
- `Move Up`（上移）或 `[Ctrl+Up]` 或 ![up](img/undo.png) —— 将选中行上移。
- `Move Down`（下移）或 `[Ctrl+Down]` 或 ![down](img/redo.png) —— 将选中行下移。
- `Import selected rows to CSV format`（将选中行导出为 CSV 格式）或 ![import](img/import.png) —— 将选中行保存到 CSV 文件。

最新版本的芯片数据库文件可以从此页面以 .Dat 和 .csv 两种格式下载。

## 芯片数据库更新器

运行 IMSProg_database_update 程序后，下载的数据库会被复制到 ~/.local/share/imsprog 文件夹。脚本随后会显示更新前后数据库中的芯片数量。

## 支持的芯片列表

### I2C EEPROM
24C01, 24C02, 24C04, 24C08, 24C16, 24C32, 24C64, 24C128, 24C256, 24C512,
24LC515*, 24C1024, 24LC1025*, 24M02

> [!NOTE]
> *对于 24LC515 和 24LC1025：引脚 3 必须与接地引脚断开，并通过 4.7 kΩ 电阻连接到 VCC 引脚。*

### I2C FeRAM（铁电存储器）
- RAMXEED

MB85RC04, MB85RC16, MBRC64, MB85RC128, MB85RC256, MB85RC512, MB85RC1MT

- RAMTRON

FM24C04A, FM24C16A, FM24C32A, FM24C64A, FM24C128, FM24C256, FM24C512, FM24CL04A,
FM24CL16A, FM24CL32A, FM24CL64A

### MicroWire EEPROM（仅适用于 CH341A 编程器）
93C46, 93C56, 93C66, 93C76, 93C86

### 串行 SPI 总线 EEPROM
- ST

M95010, M95020, M95040, M95080, M95160, M95320, M95640, M95128, M95256, M95512,
M95M01, M95M02

- ATMEL

AT25010, AT25020, AT25040, AT25080, AT25160, AT25320, AT25640, AT25128, AT25256,
AT25F512, AT25F1024, AT25F2048, AT25F4096

- MICROCHIP

25AA010, 25AA020, 25AA040, 25AA080, 25AA160, 25AA320, 25AA640, 25AA128, 25AA256,
25AAF512, 25AAF1024, 25LC010, 25LC020, 25LC040, 25LC080, 25LC160, 25LC320,
25LC640, 25LC128, 25LC256, 25LC512, 25LC1024

- ONSEMI

CAT25C01, CAT25C02, CAT25C04, CAT25C08, CAT25C16, CAT25C32, CAT25C64, CAT25C128,
CAT25C256, CAT25C512

### 串行 SPI 总线 FeRAM（铁电存储器）
- RAMXEED

MB85RS16N, MB85RD16LX, MB85RS64VY, MB85RS64V, MB85RS128TY, MB85RS128B,
MB85RS256TY, MB85RS256LYA, MB85RS256B, MB85RS512TY, MB85RS512LY, MS85RS1MLY,
MB85RS1MT, MB85RS2MTY, MB85RS2MLY, MB85RS4MTY, MB85RS4MLY

### DataFlash 45xx
- ATMEL

AT45DB011, AT45DB021, AT45DB041, AT45DB081, AT45DB161, AT45DB321

- ADESTO

AT45DB011, AT45DB021, AT45DB041, AT45DB081, AT45DB161, AT45DB321, AT45DB641

### SPI NOR Flash
- SPANSION

FL016AIF, S25FL016P, S25FL032P, FL064AIF, S25FL064P, S25FL256S, S25FL128P,
S25FL129P, S25FL204K, S25FL208K, S25FL116K, S25FL132K, S25FL164K

- XTX

XT25F02E, XT25F04D, XT25F08B, XT25F16B, XT25F32F, XT25F64F, XT25F128F,
XT25F256B, XT25W02E, XT25W04D, XT25Q08D(1.8V), XT25Q16D(1.8V), XT25Q64D(1.8V),
XT25F128D(1.8V)

- ACE

ACE25AC512G, ACE25AC100G, ACE25AC200G, ACE25AC400G

- EON

EN25B10T, EN25B20T, EN25B40T, EN25B80T, EN25B16T, EN25B32T, EN25B64T, EN25P64,
EN25Q40A, EN25Q80B, EN25Q16, EN25Q32C, EN25Q64, EN25Q128, EN25F10A, EN25F20A,
EN25F40, EN25F80, EN25F16, EN25F32, EN25S10A(1.8V), EN25S20A(1.8V),
EN25S40A(1.8V), EN25S80B(1.8V), EN25S16B(1.8V), EN25S64A(1.8V), EN25QE16A,
EN25QE32A, EN25E10A, EN25E40A, EN25SE16A(1.8V), EN25SE32A(1.8V), EN25T80,
EN25T16, EN25QA32B, EN25QA64A, EN25QA128A, EN25QW16A, EN25QW32A, EN25QH16,
EN25QH32B, EN25QH64A, EN25QH128A, EN25Q256, EN25QX64A, EN25QX128A, EN25QX256A,
EN25QY256A, EN25SX64A(1.8V), EN25SX128A(1.8V)

- ATMEL

AT25LS321(1.8V), AT25LS128A(1.8V), AT25LS641(1.8V), AT26DF161, AT25DF321,
AT25DF641

- MICRON

M25P10, M25P20, M25P40, M25P80, M25P016, M25P32, M25P64, M25P128, N25Q032A,
N25Q064A, MT25QL64AB, N25Q128A, MT25QL128AB, N25Q256A, MT25QL256AB, MT25QL512AB,
N25Q032A(1.8V), N25Q064A(1.8V), MT25QU64AB(1.8V), N25Q128A(1.8V),
MT25QU128AB(1.8V), MT25QU256AB(1.8V), MT25QU512AB(1.8V)

- XMC

XM25QH10B, XM25QH20B, XM25QH40B, XM25QH80B, XM25QH16C, XM25QH32B, XM25QH64C,
XM25QH128C, XM25QH256C, XM25QH512C, XM25LU64C(1.8V), XM25LU128C(1.8V),
XM25QU256C(1.8V), XM25QU512C(1.8V), XM25QW16C, XM25QW32C, XM25QW64C, XM25QW128C,
XM25QW256C, XM25QW512C, XM25QU41B(1.8V), XM25QU80B(1.8V), XM25QU16C(1.8V),
XM25LU32C(1.8V), XM25QH32A, XM25QH64A, XM25QH128A

- AMIC

AT25L05P, A25L10PU, A25L20PU, A25L40PU, A25L80PU, A25L16PU, A25L10PT, A25L20PT,
A25L40PT, A25L80PT, A25L16PT, A25L010, A25L020, A25L040, A25L040, A25L080,
A25L016, A25L032, A25LQ080, A25LQ16, A25LQ32, A25LQ64

- EXCELSEMI

ES25P10, ES25P20, ES25P40, ES25P80, ES25P16, ES25P32, ES25M40A, ES25M80A,
ES25M16A

- DOUQI

DQ25Q64AS

- Zbit

ZB25LD10A(1.8V), ZB25LD20A(1.8V), ZB25LD40B(1.8V), ZB25LD80(1.8V), ZB25D10A,
ZB25D20A, ZB25D40B, ZB25D80B, ZB25VQ16, ZB25VQ32, ZB25VQ64, ZB25VQ128,
ZB25LQ16(1.8V), ZB25LQ32(1.8V), ZB25LQ64(1.8V), ZB25LQ128(1.8V), ZB25VQ20A,
ZB25VQ40A, ZB25VQ80A, ZB25VQ16A, ZD25D20, ZD25D40, ZD25D80

- ONSemi

LE25U20AMB, LE25U40CMC

- Boya

BY25Q05AW, BY25Q10AW, BY25Q20BL(1.8V), BY25Q40BL, BY25Q80AW(1.8V),
BY25Q16BL(1.8V), BY25D05AS, BY25D10AS, BY25D20AS, BY25D40AS, BY25Q80BS,
BY25Q16BS, BY25Q32BS, BY25Q64AS, BY25Q128AS, BY25Q256ES, BY25Q10AL(1.8V),
BY25Q20AL(1.8V), BY25Q40AL(1.8V), BY25Q32AL(1.8V), BY25Q64AL(1.8V),
BY25Q128EL(1.8V)

- PFLASH

Pm25LQ512B, Pm25LQ010B, Pm25LD020, Pm25LQ020B, PM25LQ016, PM25LQ032, PM25LQ064,
PM25LQ128, Pm25LV010, Pm25LV020, Pm25LQ040B, Pm25LV040

- Puya

P25Q06H, P25Q40H, PY25Q128HA, PY25Q256HB, PY25Q512HB, P25Q11H, P25Q21H, P25Q10H,
P25Q20H, P25Q80H, P25Q16H, P25Q32H, P25Q64H, P25Q128H

- ESMT

F25L004A, F25L008A, F25L016, F25L032, F25L064, F25L16QA, F25L32QA, F25L64QA

- ISSI

IS25WQ020(1.8V), IS25WQ040(1.8V), IS25WQ080(1.8V), IS25LQ010, IS25LQ020,
IS25LP040E, IS25LP080D, IS25LP016D, IS25LP032D, IS25LP064D, IS25LP128F,
IS25LP256D, IS25LP512D, IS25WP512E(1.8V), IS25WP010E(1.8V), IS25WP020E(1.8V),
IS25WP040D(1.8V), IS25WP080D(1.8V), IS25WP016D(1.8V), IS25WP032D(1.8V),
IS25WP064D(1.8V), IS25WP128F(1.8V), IS25WP256D(1.8V), IS25WP512D(1.8V)

- Fudan

FM25W02, FM25W04, FM25W16, FM25W32, FM25W64, FM25W128, FM25F005, FM25F01B,
FM25F02A, FM25F04A, FM25Q04, FM25Q08, FM25Q16, FS25Q32, FS25Q64, FS25Q128

- Zetta

ZD25Q64B, ZD25LQ128(1.8V), ZD25LQ64(1.8V), ZD25WD20B, ZD25WD40B, ZD25Q80C,
ZD25Q16B, ZD25Q32C

- PCT

PCT25VF016B, PCT25VF032B, PCT25VF064C, PCT25VF020B, PCT25VF040B, PCT25VF080B,
PCT26VF016, PCT26VF032, PCT25VF010A

- MXIC

MX25L512E, MX25L1006E, MX25L2005, MX25L4005A, MX25L8005M, MX25L1605D,
MX25L3205D, MX25L6405D, MX25L12805D, MX25L25635E, MX25L51245G, MX25L5121E,
MX25L1021E, MX25L1633E, MX25L1635E, MX25U5121E(1.8V), MX25U1001E(1.8V),
MX25U2035F(1.8V), MX25U4035F(1.8V), MX25U80356(1.8V), MX25U1632F(1.8V),
MX25U3232F(1.8V), MX25U6432F(1.8V), MX25U12832F(1.8V), MX25U25643G(1.8V),
MX25U51245G(1.8V), MX25L1655D, MX25L6455E, MX25L12855E, MX25L25655E, MX25R1035F,
MX25R2035F, MX25R4035F, MX25R8035F, MX25R1635F, MX25R3235F, MX25R6435F,
MX25L3225D, MX25L3255D

- Giantec

GT25D05C, GT25D10C, GT25D20C, GT25Q40C, GT25D05E, GT25D10E, GT25D20E, GT25Q80A,
GT25Q16A, GT25Q32A-H, GT25Q64A-S

- GigaDevice（兆易创新）

GD25F40, GD25F80, GD25D40, GD25D80, GD25D05C, GD25D10C, GD25Q20C, GD25Q40C,
GD25Q80C, GD25Q16C, GD25Q32, GD25Q64CSIG, GD25Q128CSIG, GD25Q256CSIG, GD25VQ21B,
GD25VQ40C, GD25VQ80C, GD25VQ16C, GD25LD05C(1.8V), GD25LD10C(1.8V),
GD25LD20C(1.8V), GD25LD40C(1.8V), GD25LQ80C, GD25LQ16C, GD25LQ32E,
GD25LQ64E(1.8V), GD25LQ128(1.8V), GD25LQ256D(1.8V), GD25WD05C, GD25WD10C,
GD25WD20E, GD25WD40E, GD25WD80C, GD25WQ20E, GD25WQ40E, GD25WQ80E, GD25WQ16E,
GD25WQ32E, GD25WQ64E, GD25WQ128E, GD25WB256E, GD25LB512ME(1.8V), YC25Q128

- Nantronix

N25S80, N25S32

- PARAGON

PN25F08, PN25F16, PN25F32, PN25F64, PN25F128

- DOSILICON

DS25Q64A, DS25Q4AA, DS25M4CB, DS25M64E, DS25M4AE, DS25M4AB, DS25M4BA

- WINBOND（华邦）

W25P80, W25P16, W25P32, W25P64, W25X05, W25X10, W25X20, W25X40, W25X80, W25X16,
W25X32VS, W25X64, W25Q05CL, W25Q10Cl, W25Q20CL, W25Q40BV, W25Q80BL, W25Q16DV,
W25Q32BV, W25Q64BV, W25Q128BV, W25Q256FV, W25Q20BW(1.8V), W25Q80,
W25Q10EW(1.8V), W25Q20EW(1.8V), W25Q40EW(1.8V), W25Q80EW(1.8V), W25Q16JW(1.8V),
W25Q32FW(1.8V), W25Q64DW(1.8V), W25Q128FW(1.8V), W25Q256JW(1.8V),
W25M512JW(1.8V), W25Q512JV, W25M512JV, W25Q32JW(1.8V)

- Fidelix

FM25Q04A, FM25Q08A, FM25Q16A, FM25Q32A, FM25Q64A, FM25Q128A, FM25M04A(1.8V),
FM25M08A(1.8V), FM25M16A(1.8V), FM25M32A(1.8V), FM25M64A(1.8V), FM25M4AA(1.8V)

- UCUNDATA (UCUN Technology)

UC25HQ05, UC25HQ10, UC25HQ20, UC25HQ40, UC25HQ80, UC25HQ16, UC25HQ32, UC25HQ64,
UC25IQ128

### SPI NAND Flash

- ESMT

F50L2G41XA, F50L1G41LB(2M), F50L512M41A, F50L4G41XB

- MICRON

MT29F4G01ABBFD12, MT29F4G01ABAFD12, MX35LF1G24AD-Z41, MX35LF2G24AD-Z41

- MXIC

MX35LF4G24AD-Z41, MX35LF2G24AD-Z418, MX35LF4G24AD-Z418, MX35LF1GE4AB,
MX35UF1G24AD-Z4I, MX35UF2G24AD-Z4I, MX35UF4G24AD-Z4I, MX35UF2G24AD-Z4I8,
MX35UF4G24AD-Z4I8, MX35UF1G14AC, MX35UF2G14AC, MX35UF1GE4AC, MX35UF2GE4AC,
MX35UF1GE4AD, MX35UF2GE4AD, MX35UF4GE4AD, MX35LF2GE4AD, MX35LF4GE4AD

- WINBOND（华邦）

W25N512GW, W25N512GV, W25N01KW, W25N01KV, W25N01JW, W25N01GW, W25N01GV,
W25N02KW, W25N02KV, W25N02JW, W25N04LW, W25N04KW, W25N04KV

- XTX

XT26G01C, XT26G01A, XT26G01D, XT26G11C, XT26G11D, XT26Q01D, XT26G02D, XT26G02C,
XT26G12D-B, XT26Q02D, XT26Q04D
XTX	XT26Q14D

- Dosilicon

DS35Q12B, DS35M12B, DS35Q12C, DS35M12C, DS35Q1GA, DS35M1GA, DS35Q1GB, DS35M1GB,
DS35Q2GA, DS35M2GA, DS35Q2GB, DS35M2GB, DS35Q2GBS, DS35M2GBS, DS35Q4GM,
DS35Q4GM, DS35Q4GB, DS35M4GB

- ZETTA

ZD35Q1GC-IB

- FORESEE

F35SQA001G, F35SQB004G, F35SQA512M, F35UQA002G, F35SQA002G, GD5F1GQ5UExxG

- GigaDevice（兆易创新）

GD5F1GQ5RExxG, GD5F1GM7UExxG, GD5F1GM7RExxG, GD5F1GM9UExxG, GD5F1GM9RExxG,
GD5F1GQ4UFxxG, GD5F1GQ4RFxxG, GD5F1GQ4UAxxG, GD5F2GQ5UExxG, GD5F2GQ5RExxG,
GD5F2GM7UExxG, GD5F2GM7RExxG, GD5F4GQ6UExxG, GD5F4GQ6RExxG, GD5F4GM8UExxG,
GD5F4GM8RExxG, GD5F1GQ4UExxG, GD5F1GQ4RExxG, GD5F1GQ4UFxxS, GD5F1GQ4RFxxS,
GD5F2GQ4UExxG, GD5F2GQ4RExxG

最新版本的芯片数据库可以
[在此](https://antenna-dvb-t2.ru/dl_all/IMSProg.Dat)找到。
你可以下载它并复制到 ~/.local/share/imsprog 文件夹：

`cp IMSProg.Dat ~/.local/share/imsprog`

## 软件包
- 正在努力将 IMSProg 加入官方 `Debian`（及其衍生发行版）仓库。

  对于某些 Ubuntu 版本，你可以通过向系统的软件源添加 `ppa:bigmdm/imsprog` 来使用这个 PPA。
```
sudo add-apt-repository ppa:bigmdm/imsprog
sudo apt update
sudo apt install imsprog
```
  也可以使用 `debian/latest` 分支手动构建 deb 包。

- 对于某些 Fedora 版本，你可以使用官方仓库。
```
sudo dnf install imsprog
```

<a href="https://repology.org/project/imsprog/versions">
    <img src="https://repology.org/badge/vertical-allrepos/imsprog.svg" alt="Packaging status" align="right">
</a>

- 由 [Red Soft](https://redos.red-soft.ru/) 提供的 `RPM 包` 可以
[在此](http://repo.red-soft.ru/redos/7.3/x86_64/updates/)下载
- 由 [ALT Linux](https://packages.altlinux.org/en/sisyphus/srpms/IMSProg/) 提供的 `RPM 包`
- 由 [ROSA Linux](https://mirror.rosalinux.ru/rosa/rosa2021.1/repository/x86_64/contrib/release/) 提供的 `RPM 包`
- 由 [kjkent](https://github.com/kjkent) 提供的 `ARCH AUR 仓库` 在 [此处](https://aur.archlinux.org/packages/imsprog)
- `openSUSE` 包在 [此处](https://software.opensuse.org/package/IMSProg?search_term=imsprog)
- `Debian` 包在 [此处](https://tracker.debian.org/pkg/imsprog)
- 由 [Anime4000](https://github.com/Anime4000) 提供的 Windows 版本在 [此处](https://github.com/Anime4000/IMSProg/releases/latest)

## 项目结构

```
IMSProg _files_（文件）			                      _folder_（文件夹）
================================================================================
IMSProg                                                  /usr/bin
IMSProg_editor                                           /usr/bin
IMSProg_database_update                                  /usr/bin

IMSProg_programmer/database/IMSProg.Dat                  /usr/share/imsprog
                                                         ~/.local/share/imsprog

IMSProg_programmer/other/71-CH341.rules                  /lib/udev/rules.d

IMSProg_programmer/other/index.html                      /usr/share//doc/imsprog/html

IMSProg_programmer/language/chipProgrammer_ru_RU.qm      /usr/share/imsprog
IMSProg_programmer/language/chipProgrammer_es_ES.qm      /usr/share/imsprog
IMSProg_programmer/language/chipProgrammer_de_DE.qm      /usr/share/imsprog
IMSProg_programmer/language/chipProgrammer_zH_CN.qm      /usr/share/imsprog
IMSProg_programmer/language/chipProgrammer_uk_UA.qm      /usr/share/imsprog
IMSProg_programmer/language/chipProgrammer_hu_HU.qm      /usr/share/imsprog
IMSProg_programmer/language/chipProgrammer_pt_BR.qm      /usr/share/imsprog

IMSProg_editor/language/chipEditor_ru_RU.qm              /usr/share/imsprog
IMSProg_editor/language/chipEditor_de_DE.qm              /usr/share/imsprog
IMSProg_editor/language/chipEditor_es_ES.qm              /usr/share/imsprog
IMSProg_editor/language/chipEditor_zh_CN.qm              /usr/share/imsprog
IMSProg_editor/language/chipEditor_uk_UA.qm              /usr/share/imsprog
IMSProg_editor/language/chipEditor_hu_HU.qm              /usr/share/imsprog
IMSProg_editor/language/chipEditor_pt_BR.qm              /usr/share/imsprog

IMSProg_database_update/language/chipUpdater_ru_RU.qm    /usr/share/imsprog
IMSProg_database_update/language/chipUpdater_de_DE.qm    /usr/share/imsprog
IMSProg_database_update/language/chipUpdater_es_ES.qm    /usr/share/imsprog
IMSProg_database_update/language/chipUpdater_zh_CN.qm    /usr/share/imsprog
IMSProg_database_update/language/chipUpdater_uk_UA.qm    /usr/share/imsprog
IMSProg_database_update/language/chipUpdater_hu_HU.qm    /usr/share/imsprog
IMSProg_database_update/language/chipUpdater_pt_BR.qm    /usr/share/imsprog

IMSProg_programmer/other/IMSProg.desktop                 /usr/share/applications
IMSProg_programmer/other/IMSProg_editor.desktop          /usr/share/applications
IMSProg_database_update/other/IMSProg_database_update.desktop /usr/share/applications

IMSProg_editor/other/IMSProg_editor.1.gz                   /usr/share/man/man1
IMSProg_programmer/other/IMSProg.1.gz                      /usr/share/man/man1
IMSProg_database_update/other/IMSProg_database_update.1.gz /usr/share/man/man1

IMSProg_programmer/img/IMSProg64.png                     /usr/share/pixmaps
IMSProg_database_update/img/IMSProg_database_update.png  /usr/share/pixmaps
img/chipEdit64.png                        /usr/share/pixmaps

IMSProg_programmer/other/other/io.github.bigbigmdm.imsprog.metainfo.xml /usr/share/metainfo
IMSProg_editor/other/other/io.github.bigbigmdm.imsprog_editor.metainfo.xml /usr/share/metainfo
IMSProg_database_update/other/io.github.bigbigmdm.imsprog_database_update.metainfo.xml /usr/share/metainfo

```
## 芯片数据库格式

IMSProg.Dat 文件结构：

芯片记录字符串长度：0x44（68）字节；

```
偏移      大小    值
00 -     2F     ASCII 芯片类型、名称和厂商，0x00 填充
30        1     NOR FLASH 芯片容量代码   / 0x00 —— 其他芯片
31        1     NOR FLASH 芯片 ID 代码   / 0x00 —— 其他芯片
32        1     NOR FLASH 厂商代码       / 0x00 —— 其他芯片
33              0x00
34        4     芯片容量
35
36
37
38        2     扇区大小
39
3A        1     二进制芯片类型：
                - 0x00 —— SPI NOR FLASH
                - 0x01 —— 24xxx I2C
                - 0x02 —— 93xxx MicroWire
                - 0x03 —— 25xxx SPI EEPROM
                - 0x04 —— 95xxx ST SPI EEPROM
                - 0x05 —— AT45DBxxx SPI EEPROM
3B        1     算法代码编号：
                - SPI NOR Flash 始终为 0x00
                - I2C (24xxx) 0x?1 —— 地址大小为 1 字节
                - I2C (24xxx) 0x?2 —— 地址大小为 2 字节
                - I2C (24xxx) 0x?A —— 地址大小为 2 字节，用于 24LC1025
                - I2C (24xxx) 0x?E —— 地址大小为 2 字节，用于 24LC515
                - I2C (24xxx) 0x1? —— 地址掩码 1
                - I2C (24xxx) 0x3? —— 地址掩码 3
                - I2C (24xxx) 0x7? —— 地址掩码 7
                - MicroWire (93xxx) —— 0x1? —— 16 位组织结构
                - MicroWire (93xxx) —— 0x0? —— 8 位组织结构
                - MicroWire (93xxx) —— 0x?7 —— 7 位地址数
                - MicroWire (93xxx) —— 0x?9 —— 9 位地址数
                - MicroWire (93xxx) —— 0x?A —— 10 位地址数
                - MicroWire (93xxx) —— 0x?B —— 11 位地址数
                - 95xxx ST SPI EEPROM —— 0x01 —— 8 位地址
                - 95xxx ST SPI EEPROM —— 0x02 —— 16 位地址
                - 25xxx SPI EEPROM  —— 0x?0 —— 8 位地址
                - 25xxx SPI EEPROM  —— 0x?1 —— 16 位地址
                - 25xxx SPI EEPROM  —— 0x?2 —— 24 位地址
                - 25xxx SPI EEPROM  —— 0x0? —— 填充擦除
                - 25xxx SPI EEPROM  —— 0x1? —— 命令的第三位用于地址高位
                - 25xxx SPI EEPROM  —— 0x2? —— 使用 CHIP FULL ERASE（整片擦除）命令擦除
                - 45xxx SPI EEPROM  —— 0x0? —— ATMEL 命令模式
                - 45xxx SPI EEPROM  —— 0x1? —— ADESTO 命令模式
                - 45xxx SPI EEPROM  —— 0x?9 —— 9 位扇区地址数
                - 45xxx SPI EEPROM  —— 0x?A —— 10 位扇区地址数
                - 45xxx SPI EEPROM  —— 0x?B —— 11 位扇区地址数
                - 45xxx SPI EEPROM  —— 0x?C —— 12 位扇区地址数
                - 45xxx SPI EEPROM  —— 0x?D —— 13 位扇区地址数
                - 45xxx SPI EEPROM  —— 0x?F —— 15 位扇区地址数
                - SPI NOR Flash —— 用于操作安全寄存器的算法编号
                - SPI NAND Flash —— 用于读取状态寄存器和安全寄存器的算法编号
3C        2     延时总线速度系数：
3D             bus_speed = default_bus_speed * Delay / 1000
3E        2     SPI NOR Flash 4 位地址类型：
                - 0x?0 —— 未使用（3 位地址数据）
                - 0x?1 —— 已使用（4 位地址数据）
                - 0x01 —— 默认使用 4 位命令
                - 0x11 —— Winbond 算法
                - 0x21 —— Spansion 算法
3F        1     0x00
40        1     SPI NOR FLASH 块大小，单位 KB（64K = 0x40）
41        1     0x00
42        1     - EEPROM 页数 0x01 - 0x04
                - 对于 SPI NAND Flash —— ECC 大小 / 64
43        1     VCC 00=>3.3V 01=>1.8V 02=>5.0V 03=>2.5V
记录的结尾是 0x44（68）个零字节。
```
默认总线速度：

| 芯片类型 / 编程器 | CH341a v1.2 | CH341a v1.7 | CH347t v1.0 | CH347T v1.1 | FH232H v1.2 |
| :---               |    :---:    |    :---:    |    :---:    |    :---:    | :---:  |
| SPI NOR Flash      |  1.6 Mhz    |   1.6 Mhz   |   30 Mhz    |   15 Mhz    | 30 Mhz |
| 25xxx EPROM        |  1.6 Mhz    |   1.6 Mhz   |    5  Mhz   |   5  Mhz    |  5 Mhz |
| 24xxx EPROM        |  0.4 Mhz    |   0.4 Mhz   |   0.4  Mhz  |   0.4  Mhz  | 0.4 Mhz|
| 93xxx EPROM        |  1.6 Mhz    |   1.6 Mhz   |    5  Mhz   |   5  Mhz    |  5 Mhz |
| 45xxx DataFlash    |  1.6 Mhz    |   1.6 Mhz   |    5  Mhz   |   5  Mhz    |  5 Mhz |
| SPI NAND Flash     |  1.6 Mhz    |   1.6 Mhz   |   60 Mhz    |   15 Mhz    | 30 Mhz |

## 许可证

版权所有 (C) 2023 - 2026 Mikhail Medvedev。
本项目使用 [GPL-3+ 许可证](https://www.gnu.org/licenses/gpl-3.0.html)，
部分取自项目 [SNANDer](https://github.com/McMCCRU/SNANDer/commits?author=McMCCRU)
的部分为 [GPL-2+](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)，
取自 [QHexEdit2](https://github.com/Simsys/qhexedit2) 的部分为 [LGPL-2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)，
取自 [CH347](https://github.com/981213/ch347-nor-prog/tree/master) 的部分为 [BSD-1-Clause](https://github.com/spdx/license-list-data/blob/main/text/BSD-1-Clause.txt)。

## 翻译

- 匈牙利语翻译由 [blackPantherOS](https://github.com/blackPantherOS)
- 意大利语翻译由 Marino Pasquale 和 [Giovanni Scafora](https://github.com/giovanni69)
- 巴西葡萄牙语翻译由 [Alexandre C. Leite](https://github.com/alexandrecleite)
- 乌克兰语翻译由 [Sergey Golovko](https://github.com/cappelikan)
- 中文（简体）翻译由 [Tian-HP](https://github.com/Tian-HP)
- 德语翻译由 [wucke13](https://github.com/wucke13)
- 中文（繁体）翻译由 [ystartgo](https://github.com/ystartgo)

任何人都可以通过提交 Pull Request 来添加或改进翻译。
翻译文件位于：[IMSProg_programmer/language/](https://github.com/bigbigmdm/IMSProg/tree/main/IMSProg_programmer/language) 和 [IMSProg_editor/language/](https://github.com/bigbigmdm/IMSProg/tree/main/IMSProg_editor/language)
以及 [IMSProg_database_update/language/](https://github.com/bigbigmdm/IMSProg/tree/main/IMSProg_database_update/language)

你也可以为桌面文件添加翻译（[IMSProg.desktop](https://github.com/bigbigmdm/IMSProg/blob/main/IMSProg_programmer/other/IMSProg.desktop)、
 [IMSProg_database_update.desktop](https://github.com/bigbigmdm/IMSProg/blob/main/IMSProg_programmer/other/IMSProg_database_update.desktop)、
  [IMSProg_editor.desktop](https://github.com/bigbigmdm/IMSProg/blob/main/IMSProg_editor/other/IMSProg_editor.desktop)），

以及 appstream 元数据文件（[io.github.bigbigmdm.imsprog_editor.metainfo.xml](https://github.com/bigbigmdm/IMSProg/blob/main/IMSProg_editor/other/io.github.bigbigmdm.imsprog_editor.metainfo.xml)、
[io.github.bigbigmdm.imsprog_database_update.metainfo.xml](https://github.com/bigbigmdm/IMSProg/blob/main/IMSProg_programmer/other/io.github.bigbigmdm.imsprog_database_update.metainfo.xml)、
[io.github.bigbigmdm.imsprog.metainfo.xml](https://github.com/bigbigmdm/IMSProg/blob/main/IMSProg_programmer/other/io.github.bigbigmdm.imsprog.metainfo.xml)）。

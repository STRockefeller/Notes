# Dart kernel

折騰了1.5小時才搞定，必須記下來，免得之後又得花費一堆時間弄這東西= =

首先我用的是這個版本的kernel [GitHub - vickumar1981/jupyter-dart-kernel: Dart Kernel for Jupyter Notebooks](https://github.com/vickumar1981/jupyter-dart-kernel)

現階段能找到的dart kernel其實也只有這個而已。沒得選

安裝環境是win10

先根據官方的文件安裝

### Requirements

- Dart
- Python 3
- Jupyter

### Steps

1. [Install Dart](https://dart.dev/get-dart) for your platform
2. [Install Jupyter](http://jupyter.org/install.html)
3. Download the kernel and save it somewhere memorable. The important files are `kernel.json` and `dartkernel.py`
4. Install the kernel into Jupyter: `jupyter kernelspec install /path/to/dartkernel --user`
- You can verify the kernel installed correctly: `jupyter kernelspec list`
- It will appear in the list of kernels installed under the name of the project folder
5. Run Jupyter and start using Dart
- To use the kernel in the Jupyter console: `jupyter console --kernel kernelname`
- to use the kernel in a notebook: `jupyter notebook` and create a new notebook through the browser

其中 jupyter 需要另外安裝，用來測試kernel還滿方便的。

安裝完之後在list會看到新安裝的kernel但是實際執行時不管是在jupyter notebook裡面(可以選擇但執行會出錯) 或者 jupyter console 都會發生 no module named dartkenel 的錯誤。

以下是我除此之外有進行的變動，最後是可以順利執行了，但我不確定哪個操作才是關鍵，總之先都記下來下次安裝的時候再來試試看。

1. 把除了`dartkernel.py` 和 `kernel.json` 以外的部分都刪除掉，主要是因為`.git`裡面有東西在uninstall的時候會被windows拒絕存取，所以反覆操作的時候覺得很麻煩就刪除掉了。

2. 新增環境變數`PYTHONPATH`參考這篇文章[python - How to add to the PYTHONPATH in Windows, so it finds my modules/packages? - Stack Overflow](https://stackoverflow.com/questions/3701646/how-to-add-to-the-pythonpath-in-windows-so-it-finds-my-modules-packages)

3. 在 `kernel.json` 中新增`.py`路徑[reference issue](https://github.com/vickumar1981/jupyter-dart-kernel/issues/4)
   
   ```json
   {
       "argv": ["python", "-m", "dartkernel", "-f", "{connection_file}"],
       "display_name": "Dart",
       "env": {
           "PYTHONPATH": "C:/Users/rockefel/AppData/Roaming/jupyter/kernels/dartkernel/dartkernel.py"
       }
   }
   ```

4. 在python path中把`.py`放進去[reference issue](https://github.com/vickumar1981/jupyter-dart-kernel/issues/2)
   
   ![](https://i.imgur.com/TtkvaQP.png)

都完成後再次用console執行就可以成功了

![](https://i.imgur.com/aDwxIyv.png)

vscode則是要重新啟動才可以使用新安裝的kernel

![](https://i.imgur.com/ZNm3Ygp.png)

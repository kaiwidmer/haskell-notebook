import CodeMirror from "codemirror";
import 'codemirror/lib/codemirror.css';
import 'codemirror/mode/haskell/haskell';
import playImage from '../static/play.svg';
import loadingImage from '../static/loading.gif'
import './style.css'

let textAreas = document.getElementsByClassName("code-editor")
let editorList = []
for (let textArea of textAreas) {
    let editor = CodeMirror.fromTextArea(textArea, {
        mode: "haskell",
        lineNumbers: true,
        readOnly: false,
    })
    editorList.push(editor)

    let resultDiv = document.createElement('div');
    textArea.parentNode.after(resultDiv)

    let playButton = new Image();
    playButton.src = playImage;
    playButton.width = 32
    playButton.height = 32
    playButton.addEventListener("click", () => {
        playButton.src = loadingImage;
        fetch("http://localhost:8000/run", {
            method: "POST",
            body: getCodeInScope(editor)
        }).then(response => {
            response.text().then(responseText => {
                resultDiv.textContent = responseText
            })
            playButton.src = playImage;
        })
    })
    textArea.parentNode.insertBefore(playButton, textArea);
}

function getCodeInScope(searchedEditor) {
    let codeInScope = ""
    for (let editor of editorList) {
        if (editor == searchedEditor) {
            return codeInScope + editor.getValue();
        }
        let codeLine = editor.getValue().split('\n').filter(line => !line.startsWith(":")).join("\n");
        codeInScope = codeInScope + "\n" + codeLine;
    }
    return codeInScope;
}
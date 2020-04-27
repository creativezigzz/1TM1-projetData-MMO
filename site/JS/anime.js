"use strict";

/**
 * cette fonction permet de cree le select des genre dans le html.
 */
function initGenre(){
    let xhr = new XMLHttpRequest();
    xhr.open('get',"");
    xhr.onload = function reponse(){
        let obj = JSON.parse(xhr.responseText);
        let stringHtlm = "";
        for(let i of obj){
            stringHtlm += `<option value="${i.genrId}">${i.genrNom}</option>`;
        }
        //document.getElementById().
    };
    xhr.send();
}
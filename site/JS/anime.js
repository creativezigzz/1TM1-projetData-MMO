"use strict";

/**
 * cette fonction permet de cree le select des genre dans le html.
 */

function initForm(){
    xhrReqJson('http://localhost/getGenrList',reponse,'genre');
}

function reponse(obj,id){
    let stringHtlm = "";
    for(let i of obj){
        stringHtlm += `<option value="${i.genrId}">${i.genrNom}</option>`;
    }
    setElem(id,stringHtlm);
}
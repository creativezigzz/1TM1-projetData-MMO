"use strict";


/**
 * fonction d'initialisation de la page form.html
 */
function initForm(){
    xhrReqJson('http://localhost/getGenrList/',reponse,'genre');
}
/**
 * cette fonction permet de cree le select des genre dans le html.
 *
 * @obj {array} objet qui sera utiliser pour former le select
 * @id {string} id de la page html ou les données iront
 */
function reponse(obj,id){
    let stringHtml = "";
    for(let i of obj){
        stringHtml += `<option value="${i.id}">${i.genre}</option>`;// création des options
    }
    setElem(id,stringHtml);
}
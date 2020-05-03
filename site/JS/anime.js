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
    let stringHtlm = "";
    for(let i of obj){
        stringHtlm += `<option value="${i.id}">${i.genre}</option>`;// creation des option
    }
    setElem(id,stringHtlm);
}
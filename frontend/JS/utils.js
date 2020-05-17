// librairie utilitaire
// par ChL novembre 2015
//
function refElem(id){
// renvoie la référence de l'élément d'identifiant id
// s'il n'existe pas, renvoie automatiquement null
  return document.getElementById(id);
}
function getElem(id) {
// renvoie le contenu de l'élément d'identifiant id
// exemple : ... = getElem('titr');
  var e = refElem(id); // référence
  if (e) { return e.innerHTML; } // s'il existe
  return ''; // s'il n'existe pas
}
function setElem(id, v) {
// définit le contenu de l'élément d'identifiant id
// exemple : setElem('titr', 'voici le titre');
  var e = refElem(id); // référence
  if (e) { e.innerHTML = v } // s'il existe, remplace
}
function addElem(id, v) {
// ajoute la valeur v au contenu de l'élément d'identifiant id
// exemple : addElem('tb', '<tr><td>hello</td></tr>');
  var e = refElem(id); // référence
  if (e) { e.innerHTML += v } // s'il existe, ajoute
}
function setCss(id, p, v) {
// définit la proporiété css p en lui donnant la valeur v
// pour l'élément d'identifiant id
// exemple : setCss('titr', 'color', 'red');
  var e = refElem(id); // référence
  if (e) { e.style[p] = v; } // s'il existe, définit propr css
}
function setCssClass(id, c) {
// associe la classe css c à l'élément d'identifiant id
// exemple : setCssClass('titr', 'tit01')
  var e = refElem(id); // référence
  if (e) { e.className = c; } // s'il existe, définit classe
}
function getTags(o, nm){
// renvoie la collection de tags html dont le nom est nm
// au sein de l'objet o
  if (o) { return o.getElementsByTagName(nm); }
}
function getClasses(o, nm){
// renvoie la collection d'éléments html ayant une classe css de nom
// au sein de l'objet o
  if (o) { return o.getElementsByClassName(nm); }
}

// met une valeur à un cookie
function setCookie(nom, valeur) {
  document.cookie = `${nom}=${valeur}`;
}

/**
 * Récupère une valeur dans les cookies.
 * @author Mathieu Walravens
 *
 * @param {String} nom - le nom du cookie
 * @return {String} la valeur du cookie. Peut retourner undefined.
 *
 */
function getCookie(nom) {
  let cookies = document.cookie.split(';');

  for (let cookie of cookies) {
    let pair = cookie.trim().split('=');
    if (pair[0] == nom)
      return pair[1];
  }
}

/**
 * Encode les champs d'un formulaire sous forme de paramètres prêt à être envoyé à une requête GET.
 * @author Mathieu Walravens
 *
 * @param {HTMLFormElement} form - Le formulaire
 * @return {String} les paramètres encodés spéraré par des '&'.
 *
 */
function getParams(form) {
  let params = [];
  for (let el of form.elements) {
    if (el.name != "") {
      params.push(`${encodeURI(el.name)}=${encodeURI(el.value)}`);
    }
  }
  return params.join('&');
}
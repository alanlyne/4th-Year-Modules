// Alan Lyne
// 15468498

const codeDictionary = {};
const http = new XMLHttpRequest();
const proxyURL = "https://cors-anywhere.herokuapp.com/";
const stationNamesURL =
  "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML";
const stationInformationURL =
  "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML_WithNumMins?NumMins=90&format=xml&StationCode=";

// Table Function
function getStationInfo() {
  if (document.getElementById("displaytable").style.visibility === "collapse") {
    document.getElementById("displaytable").style.visibility = "visible";
  }

  // Takes user input
  let input = document.getElementById("stationName").value.toLowerCase();
  let code;

  if (codeDictionary[input] !== undefined) {
    code = codeDictionary[input];
  } else {
    code = input;
  }

  http.onreadystatechange = function () {
    if (this.readyState === 4 && this.status === 200) {
      updateTable(this.responseXML);
    }
  };

  http.open("GET", proxyURL + stationInformationURL + code, true);
  http.send();
}

// Update the table with info
function updateTable(responseXML) {
  let stationList = responseXML.getElementsByTagName("ArrayOfObjStationData")[0]
    .children;
  let tableBody = document.getElementById("tableRows");

  tableBody.innerHTML = "";

  for (let station of stationList) {
    let row = document.createElement("tr");
    row.className = "item";

    let arrivalTime = document.createElement("td");
    arrivalTime.innerText = station.getElementsByTagName(
      "Exparrival"
    )[0].innerHTML;
    row.appendChild(arrivalTime);

    let origin = document.createElement("td");
    origin.innerText = station.getElementsByTagName("Origin")[0].innerHTML;
    row.appendChild(origin);

    let destination = document.createElement("td");
    destination.innerText = station.getElementsByTagName(
      "Destination"
    )[0].innerHTML;
    row.appendChild(destination);

    let departureTime = document.createElement("td");
    departureTime.innerText = station.getElementsByTagName(
      "Expdepart"
    )[0].innerHTML;
    row.appendChild(departureTime);

    let dueTime = document.createElement("td");
    dueTime.innerText = station.getElementsByTagName(
      "Destinationtime"
    )[0].innerHTML;
    row.appendChild(dueTime);

    tableBody.appendChild(row);
  }
}

// Station Name Function
function getStationNames() {
  http.onreadystatechange = function () {
    if (this.readyState === 4 && this.status === 200) {
      buildCodeDictionary(this.responseXML);
    }
  };

  http.open("GET", proxyURL + stationNamesURL, true);
  http.send();
}

// Get station name from code
function buildCodeDictionary(responseXML) {
  let stations = responseXML.getElementsByTagName("ArrayOfObjStation")[0]
    .children;

  for (let station of stations) {
    let name = station
      .getElementsByTagName("StationDesc")[0]
      .innerHTML.toLowerCase();
    codeDictionary[name] = station.getElementsByTagName(
      "StationCode"
    )[0].innerHTML;
  }
}

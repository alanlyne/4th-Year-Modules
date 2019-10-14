import React from 'react';

import {peopleCarDB} from './carDB';

import './App.css';

const appCarDB = peopleCarDB;

function toyotaOwners(object){
	return object.car === "Toyota";
}

function flexibleAgeSearch(age){
		return function (tobject){
				return (tobject.caryear == age);
		}
}

function App() {
  return (
    <div className="App">
			<h1>CS385 Lab 2</h1>
			
			{appCarDB.filter(flexibleAgeSearch(2006)).map(person =>
				<div key = {person.id}>
					<b>{person.name}</b> {person.caryear}
				</div>
				)
			}
			
			{/*{appCarDB.filter(toyotaOwners).map(person =>
				<div key = {person.id}>
					<b>{person.name}</b> {person.caryear}
				</div>
				)
			}*/}
			
			{/*{appCarDB.map(person =>
				<div key = {person.id}>
					<b>{person.name}</b> {person.caryear} {person.miles2019} {person.car}
				</div>
				)
			}*/}
    </div>
  );
}

export default App;

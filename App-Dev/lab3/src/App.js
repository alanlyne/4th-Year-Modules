// we also need to import Component from react
import React, { Component } from "react";
import "./App.css";
// import array of Book Objects in JSON from the booksDB.js file which
// essentially is our database for today's application
import { booksDB } from "./booksDB";

// We now have our own reference to the booksDB array from Javascript
const booksArray = booksDB;

//Create a constructor which will help us maintain the state
// of data within the application

// Notice we now declare a class called App for the parent component
class App extends Component {
  constructor(props) {
    super(props); // if this is a sub class
    // We will create two state variables for this example.
    // We need an array to store our books array.
    // searchTerm stores the typed search
    // Use Lecture5 as a guide

    this.state = {
      globalBookArray: booksArray,
      searchTerm: ""
      // CS385 Lab 3 - you will need to specify the correct
      // global state variables.
    };
    // this is necessary - binding the event.
    // The syntax looks strange but must be done this way
    this.onSearchFormChange = this.onSearchFormChange.bind(this);
  } // end of constructor

  /** This is the method called when the search form box changes **/
  /** Javascript will create an event object for you **/
  onSearchFormChange(event) {
    // We re-assign the state variable called searchTerm
    // event is understood by Javascript to be a change to a UI item
    this.setState({ searchTerm: event.target.value });
    //console.log("New Search Term Typed => " + this.state.searchTerm);
  }

  // we provide the render() function which will have the JSX code
  // we want to use to 'render' this component.
  render() {
    return (
      <div className="App">
        <h1>CS385 Books Ltd</h1>
        <SearchForm
          searchTerm={this.state.searchTerm}
          onChange={this.onSearchFormChange}
        />
        <b>Current Search Term: </b> {this.state.searchTerm}
        {/* Here is the Search Results Component */}
        <SearchResults
          searchTerm={this.state.searchTerm}
          jsonArray={this.state.globalBookArray}
        />
      </div>
    ); // close bracket for return
  } // close bracket for render()
} // close bracket for App

class SearchForm extends Component {
  render() {
    // this.props are the properties which are provided or passed
    // to this component. We have the searchTerm and we have the
    // onChange function.
    const searchTermFromProps = this.props.searchTerm;
    const onChangeFromProps = this.props.onChange;

    return (
      <div className="SearchFormForm">
        <form>
          <b>Search the CS385 Book Store here: </b>
          <input
            type="text"
            value={searchTermFromProps}
            onChange={onChangeFromProps}
          />
        </form>
      </div>
    );
  }
} // close the SearchForm Component

/** We use this component to display or render the results of search**/
class SearchResults extends Component {
  // we need to write a filter function to perform our search
  // we will need to check the author and book title and genre
  // searchTerm is what is provided to us by the user in the form

  bookFilterFunction(searchTerm) {
    return function(bookObject) {
      // convert everything to lower case for string matching
      let booktitle = bookObject.booktitle.toLowerCase();
      let author = bookObject.author.toLowerCase();
      let genre = bookObject.genre.toLowerCase();
      // we also check if the searchTerm is just blank space

      return (
        searchTerm !== "" &&
        (booktitle.includes(searchTerm.toLowerCase()) ||
          author.includes(searchTerm.toLowerCase()) ||
          genre.includes(searchTerm.toLowerCase()))
      );
    };
  }

  sortBooksCallBack(bookX, bookY){
    let bookXTitle = bookX.booktitle.toLowerCase();
    let bookYTitle = bookY.booktitle.toLowerCase();

    if(bookXTitle > bookYTitle){
      return 1;
    }
    if(bookXTitle < bookYTitle){
      return -1;
    }
    return 0;
  }

  render() {
    // obtain the book array and the search term used from props
    const searchTermFromProps = this.props.searchTerm;
    const arrayPassedAsParameter = this.props.jsonArray;
    // render using filter and map functions from Javascript
    return (
      <div className="SearchResultsDisplay">
        {/* as before use filter and map together */
        /* use our specific book object filter function */

        arrayPassedAsParameter
          .filter(this.bookFilterFunction(searchTermFromProps))
          .sort(this.sortBooksCallBack)
          .map(book => (
            <tr key={book.id}>
              <td>
                [{book.isbn}]
              </td>
              <td>
                <b>{book.author}</b>
              </td>
              <td>
                <i>{book.booktitle}</i>
              </td>
              <td>{book.genre}</td>
            </tr>
          ))}
      </div>
    );
  }
} // close the SearchResults component

export default App;

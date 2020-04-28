import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import configureStore from '../redux/configureStore'
import RushingStats from './RushingStats'

const store = configureStore()

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Provider store={store}>
      <RushingStats />
    </Provider>,
    document.body.appendChild(document.createElement('div')),
  );
});

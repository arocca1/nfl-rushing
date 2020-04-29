import React from 'react'
import PropTypes from 'prop-types'

import Spinner from 'react-bootstrap/Spinner'
import Table from 'react-bootstrap/Table'

const RushingStatHeader = props => {
  return (
    <thead>
      <tr>
        <th>Player</th>
        <th>Team</th>
        <th>Pos</th>
        <th>Att/G</th>
        <th>Att</th>
        <th>Yds<img src='sorting-arrow.png' onClick={props.handleYardsSort} /></th>
        <th>Avg</th>
        <th>Yds/G</th>
        <th>TD<img src='sorting-arrow.png' onClick={props.handleTdsSort} /></th>
        <th>Lng<img src='sorting-arrow.png' onClick={props.handleLongestRunSort} /></th>
        <th>1st</th>
        <th>1st%</th>
        <th>20+</th>
        <th>40+</th>
        <th>FUM</th>
      </tr>
    </thead>
  )
}

const PlayerRushingStat = props => {
  return (
    <tr>
      <td>{props.name}</td>
      <td>{props.team_name}</td>
      <td>{props.pos}</td>
      <td>{props.attempts_per_game}</td>
      <td>{props.attempts}</td>
      <td>{props.yards}</td>
      <td>{props.yards_per_attempt}</td>
      <td>{props.yards_per_game}</td>
      <td>{props.tds}</td>
      <td>{`${props.longest}${props.is_longest_td ? 'T' : ''}`}</td>
      <td>{props.first_downs}</td>
      <td>{props.first_down_percentage}</td>
      <td>{props.runs_twenty_plus}</td>
      <td>{props.runs_forty_plus}</td>
      <td>{props.fumbles}</td>
    </tr>
  )
}

const RushingStatsTable = props => {
  if (props.loadingRushingStats) {
    return <Spinner key="TableSpinner" animation="border" />
  }

  return (
    <Table key="TableWithResults" responsive="xl" striped>
      <RushingStatHeader
        handleYardsSort={props.handleYardsSort}
        handleTdsSort={props.handleTdsSort}
        handleLongestRunSort={props.handleLongestRunSort}
      />
      <tbody>
        { props.rushingStats.map(stat => <PlayerRushingStat key={`${stat.name}Row`} {...stat} />) }
      </tbody>
    </Table>
  )
}

RushingStatsTable.defaultProps = {
  loadingRushingStats: true,
  rushingStats: [],
}

RushingStatsTable.propTypes = {
  loadingRushingStats: PropTypes.bool.isRequired,
  rushingStats: PropTypes.array.isRequired,
  handleYardsSort: PropTypes.func.isRequired,
  handleTdsSort: PropTypes.func.isRequired,
  handleLongestRunSort: PropTypes.func.isRequired,
}

export default RushingStatsTable

import React from 'react'
import PropTypes from 'prop-types'

import Spinner from 'react-bootstrap/Spinner'
import Table from 'react-bootstrap/Table'

const RushingStatsTable = props => {
  if (props.loadingRushingStats) {
   return <Spinner key="TableSpinner" animation="border" />
  }

  const tableItems = []

  return (
    <Table key="TableWithResults" responsive="xl" striped>
    </Table>
  )
}

export default RushingStatsTable

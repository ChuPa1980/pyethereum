@config @peer @wip
Feature: peer

  Scenario: send packet to peer
    Given a packet
    When peer.send_packet is called
    And all data with the peer is processed
    Then the packet sent through connection is the given packet

  Scenario: send Hello to peer
    When peer.send_Hello is called
    And all data with the peer is processed
    Then the packet sent through connection is a Hello packet

  Scenario: receive a valid Hello packet
    Given a valid Hello packet
    When peer.send_Hello is instrumented
    And received the packet from peer
    And all data with the peer is processed
    Then peer.send_Hello should be called once

  Scenario: receive two valid Hello packets
    Given a valid Hello packet
    When peer.send_Hello is instrumented
    And received the packet from peer
    And received the packet from peer
    And all data with the peer is processed
    Then peer.send_Hello should be called once

  Scenario Outline: receive an incompatible Hello packet
    Given a Hello packet with <incompatible reason> incompatible
    When peer.send_Disconnect is instrumented
    And received the packet from peer
    And all data with the peer is processed
    Then peer.send_Disconnect should be called once with args: reason

    Examples:
      | incompatible reason |
      | protocol version    |
      | network id          |

  Scenario: send Ping to peer
    When peer.send_Ping is called
    And all data with the peer is processed
    Then the packet sent through connection is a Ping packet

  Scenario: receive a Ping packet
    Given a Ping packet
    When peer.send_Pong is instrumented
    When received the packet from peer
    And all data with the peer is processed
    Then peer.send_Pong should be called once
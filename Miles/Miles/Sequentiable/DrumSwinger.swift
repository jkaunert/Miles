//
//  DrumSwinger.swift
//  Miles
//
//  Created by Lalo Martínez on 3/26/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox

/// Creates a swing drum pattern with the drum parts specified (snare, hihats, etc.)
public struct DrumSwinger: Sequentiable {
  
  public let parts: Set<DrumPart>
  
  public init(withParts parts: Set<DrumPart>) {
    self.parts = parts
  }
  
  public func addNotes(toTrack track: MusicTrack, onBeat beat: inout MusicTimeStamp) {
    
    for part in parts {
      
      var partBeat = MusicTimeStamp(0.0)
      
      for block in Rythm.DrumBeat(part: part).pattern {
        switch block {
          
        case .note(let dur):
          Note.fromMidiValue(part.noteValue).addToTrack(track, onBeat: beat + partBeat, duration: dur, velocity: part.preferedVelocity)
          partBeat += dur.valueDouble
        case .rest(let dur):
          partBeat += dur.valueDouble
        }
      }
    }
    beat += 4
  }
  
  public enum DrumPart {
    case hihats
    case bass
    case snare
    case ride
    
    /// Returns the correct note(MIDI Value) for the specified drum part
    public var noteValue: Int {
      switch self {
      case .hihats: return [42, 44].randomElement()
      case .ride: return 51
      case .bass: return 36
      case .snare: return 38
      }
    }
    
    public var preferedVelocity: Int {
      switch self {
      case .hihats: return Int.randomWith(floor: 45, ceil: 55)
      case .ride: return Int.randomWith(floor: 30, ceil: 35)
      case .bass: return Int.randomWith(floor: 40, ceil: 50)
      case .snare: return Int.randomWith(floor: 30, ceil: 45)
      }
    }
  }
  
}

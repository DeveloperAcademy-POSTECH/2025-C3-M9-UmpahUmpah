//
//  GPTPromptBuilder.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

enum GPTPromptBuilder {
    static func build(from metric: SwimMetric) -> String {
        // Mockup Data
        return """
        다음은 오늘의 수영 데이터입니다.

        - 운동 시간: 43분 24초  
        - 총 거리: 100m  
        - 칼로리: 324 kcal  
        - 평균 페이스: 2분 44초/100m  
        - 심박수: 130 bpm  
        - 랩 수: 20  

        이 데이터는 Apple Watch에서 수집된 것으로, 50대 초중반 여성 수영 초보자(수영 2개월차, 하루 1회, 주 7회 수영)의 기록입니다.  
        피드백 목적은 다음과 같습니다:

        1. 수영 실력 향상을 위한 정확하고 냉정한 피드백
        2. 각 항목(시간, 거리, 페이스, 심박수 등)에 대해 항목별로 구체적 분석 및 개선 방향 제시  
        3. (선택) 호흡과 리듬에 대한 간접 추정과 피드백 포함

        위 목적에 맞춰 전문가처럼 구체적이고 직설적인 피드백을 10줄 이하로 해주세요. 감정은 배제하고 사실과 논리에 기반한 분석만 원합니다.

        """
    }
}

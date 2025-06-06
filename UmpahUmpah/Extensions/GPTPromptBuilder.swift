//
//  GPTPromptBuilder.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

enum GPTPromptBuilder {
    static func build(from dailyInfo: DailySwimmingInfo) -> String {
        return """
        당신은 20년 경력의 전문 수영 트레이너이며, 다음 수영 데이터를 바탕으로 정확하고 구체적인 피드백과 개선방안을 제공해야 합니다.

        [사용자 프로필]
        - 50대 초중반 여성
        - 수영 입문 2개월차
        - 개선 목표: 호흡과 리듬 안정화, 지속 가능성 향상

        [오늘의 수영 데이터]
        - 운동 시간: \(Int(dailyInfo.workout.duration / 60))분 \(Int(dailyInfo.workout.duration) % 60)초
        - 총 거리: \(String(format: "%.0f", dailyInfo.workout.distance))m
        - 칼로리: \(String(format: "%.0f", dailyInfo.workout.energy)) kcal
        - 평균 페이스: \(String(format: "%.1f", dailyInfo.workout.pacePer100m))초/100m
        - 심박수: \(dailyInfo.averageHeartRate != nil ? String(format: "%.0f bpm", dailyInfo.averageHeartRate!) : "측정되지 않음")
        - 랩 수: \(dailyInfo.workout.lapCount)개

        [스트로크 분석 데이터]
        - 스트로크 효율성: \(String(format: "%.1f", dailyInfo.score.strokeEfficiency))m/stroke
        - 안정성 점수: \(String(format: "%.1f", dailyInfo.score.stabilityScore))/100
        - 몰입도 점수: \(String(format: "%.1f", dailyInfo.score.immersionScore))/100
        - 종합 점수: \(String(format: "%.1f", dailyInfo.overallScore))/100

        [피드백 작성 가이드]
        - 반드시 아래의 형식을 따라 작성할 것
        - 각 항목마다 이모지 사용
        - 내용은 반드시 구체적이고 전문적으로 작성하며, 개선 방안까지 트레이너가 하는 말처럼 제시할 것
        - 줄글이 아닌 "항목별 구분된 형태"로 제시

        [출력 형식 예시]
        🧾 요약  
        - (한 문장 요약)

        💪 강점  
        - (강점1)  
        - (강점2)

        ⚠️ 개선점  
        - (개선점1 + 이유 + 개선 제안)  
        - (개선점2 + 이유 + 개선 제안)

        이 구조를 절대 벗어나지 말고, 응답 전체는 10줄 이내로 유지해주세요.
        """
    }
}

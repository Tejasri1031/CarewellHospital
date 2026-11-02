
package com.service;

import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

import com.model.Department;

public class SymptomRecommendationService {

    public static class Recommendation {

        private final String departmentName;
        private final String reason;
        private final boolean emergency;

        public Recommendation(
                String departmentName,
                String reason,
                boolean emergency) {

            this.departmentName = departmentName;
            this.reason = reason;
            this.emergency = emergency;
        }

        public String getDepartmentName() {
            return departmentName;
        }

        public String getReason() {
            return reason;
        }

        public boolean isEmergency() {
            return emergency;
        }
    }

    public Recommendation recommendDepartment(
            String symptoms,
            List<Department> departments) {

        if (symptoms == null || symptoms.trim().isEmpty()) {

            return new Recommendation(
                    "",
                    "Please enter your symptoms.",
                    false);
        }

        String text = normalize(symptoms);
        System.out.println("NEW SYMPTOM SERVICE VERSION RUNNING");

        // Emergency warning checks.
        // These are warning phrases, not a complete emergency detector.
        System.out.println("Checking emergency warning rules");
        if (containsAny(text,
                "severe chest pain",
                "chest pain with breathlessness",
                "chest pain with difficulty breathing",
                "chest pain with sweating",
                "cannot breathe",
                "unable to breathe",
                "severe difficulty breathing",
                "unconscious",
                "not responding",
                "sudden face drooping",
                "sudden weakness on one side",
                "sudden trouble speaking",
                "heavy uncontrolled bleeding",
                "sudden extremely severe headache")) {

            return new Recommendation(
                    "",
                    "Your symptoms may indicate a medical emergency. "
                    + "Please seek emergency medical care immediately.",
                    true);
        }

        String departmentName = "General Medicine";

        String reason =
                "General Medicine is suggested for an initial "
                + "assessment of your symptoms.";

        // Pediatrics: identify child-related descriptions first.
        if (containsAny(text,
                "child fever",
                "child cough",
                "baby fever",
                "infant illness",
                "my child",
                "my baby",
                "my infant")) {

            departmentName = "Pediatrics";

            reason =
                    "A pediatric assessment may be appropriate.";

        }

        // Cardiology.
        else if (containsAny(text,
                "palpitations",
                "chest pain",
                "chest ache",
                "hear ache",
                "ribs pain",
                "irregular heartbeat",
                "heart racing",
                "heart pounding",
                "heart rhythm problem",
                "heart pain",
                "heartache")) {

            departmentName = "Cardiology";

            reason =
                    "Your symptoms may require a heart-related assessment. "
                    + "New or concerning chest symptoms need prompt medical assessment.";

        }

        // Neurology.
        // A simple headache alone does not automatically select Neurology.
        else if (containsAny(text,
                "seizure",
                "epileptic attack",
                "recurrent migraine",
                "frequent migraine",
                "recurring migraine",
                "frequent severe headache",
                "frequent headaches",
                "recurrent severe headache",
                "persistent numbness",
                "recurrent tingling")) {

            departmentName = "Neurology";

            reason =
                    "Your recurring or neurological symptoms may require "
                    + "specialist assessment.";

        }

        // Orthopedics.
        else if (containsAny(text,
                "knee pain",
                "joint pain",
                "bone pain",
                "back pain",
                "fracture",
                "knee ache",
                "knee swelling",
                "knee sweling",
                "joint swelling",
                "shoulder pain",
                "ankle pain",
                "muscle injury")) {

            departmentName = "Orthopedics";

            reason =
                    "Your symptoms may require bone, joint or muscle assessment.";

        }

        // Dermatology.
        else if (containsAny(text,
                "skin rash",
                "itching",
                "itchy skin",
                "acne",
                "eczema",
                "skin allergy",
                "skin irritation",
                "pimples on skin",
                "skin infection")) {

            departmentName = "Dermatology";

            reason =
                    "Your symptoms may require skin assessment.";

        }

        // ENT.
        else if (containsAny(text,
                "ear pain",
                "earache",
                "hearing problem",
                "hearing loss",
                "sore throat",
                "throat pain",
                "sinus problem",
                "throat infection",
                "blocked nose")) {

            departmentName = "ENT";

            reason =
                    "Your symptoms may require ear, nose or throat assessment.";

        }

        // Gynecology.
        else if (containsAny(text,
                "period problem",
                "menstrual problem",
                "irregular periods",
                "pregnancy related concern",
                "pelvic pain",
                "periods missing",
                "irregular menstruation",
                "irregular mensturation",
                "menstrual cramps")) {

            departmentName = "Gynecology";

            reason =
                    "Your symptoms may require gynecological assessment.";

        }

        // General Medicine: common symptoms and single-word inputs.
        else if (containsAny(text,
                "headache",
                "head ache",
                "head pain",
                "fever",
                "cold",
                "common cold",
                "cold fever",
                "cough",
                "bodypains",
                "body pains",
                "bodyache",
                "body ache",
                "dizziness",
                "vomiting",
                "nausea",
                "stomach pain",
                "stomach ache",
                "abdominal pain",
                "diarrhea",
                "loose motion",
                "weakness",
                "tiredness",
                "fatigue",
                "body pain")) {

            departmentName = "General Medicine";

            reason =
                    "Your symptoms may require a general medical assessment.";
        }

        // Special caution for unusual eye movements.
        else if (containsAny(text,
                "eyes rotating",
                "eye rolling",
                "eyes rolling",
                "unusual eye movements")) {

            departmentName = "General Medicine";

            reason =
                    "Unusual eye movements should be assessed promptly "
                    + "by a medical professional. Seek urgent care if they "
                    + "are sudden or accompanied by other concerning symptoms.";
        }

        // Verify that the suggested department exists in the database.
        if (departments != null) {

            for (Department department : departments) {

                if (department.getDepartmentName() != null
                        && department.getDepartmentName()
                                .equalsIgnoreCase(departmentName)) {

                    return new Recommendation(
                            department.getDepartmentName(),
                            reason,
                            false);
                }
            }
        }

        return new Recommendation(
                "",
                "The suggested department is currently unavailable.",
                false);
    }

    // Normalize different ways of entering symptoms.
    private String normalize(String symptoms) {

        String text = symptoms.toLowerCase(Locale.ROOT);

        // Remove punctuation while retaining spaces.
        text = text.replaceAll("[^a-z0-9\\s]", " ");

        // Remove unnecessary spaces.
        text = text.replaceAll("\\s+", " ").trim();

        // Common spelling and wording variations.
        text = text.replaceAll("\\bhead ache\\b", "headache");
        text = text.replaceAll("\\bhead pain\\b", "headache");
        text = text.replaceAll("\\bchest discomfort\\b", "chest pain");
        text = text.replaceAll("\\bear ache\\b", "earache");
        text = text.replaceAll("\\bbody ache\\b", "bodyache");
        text = text.replaceAll("\\bbody pains\\b", "bodypain");
        text = text.replaceAll("\\bknee sweling\\b", "knee swelling");
        text = text.replaceAll("\\birregular mensturation\\b",
                "irregular menstruation");

        return text;
    }

    // Match complete words or phrases instead of arbitrary substrings.
    private boolean containsAny(String text, String... keywords) {

        for (String keyword : keywords) {

            String expression =
                    "(?<![a-z0-9])"
                    + Pattern.quote(keyword)
                    + "(?![a-z0-9])";

            if (Pattern.compile(expression).matcher(text).find()) {
                return true;
            }
        }

        return false;
    }
}

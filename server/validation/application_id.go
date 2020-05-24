// Copyright 2019-2020 Charles Korn.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// and the Commons Clause License Condition v1.0 (the "Condition");
// you may not use this file except in compliance with both the License and Condition.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// You may obtain a copy of the Condition at
//
//     https://commonsclause.com/
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License and the Condition is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See both the License and the Condition for the specific language governing permissions and
// limitations under the License and the Condition.

package validation

import (
	"fmt"

	ut "github.com/go-playground/universal-translator"
	"github.com/go-playground/validator/v10"
)

const applicationIDValidatorTag = "applicationId"

func RegisterApplicationIDValidation(v *validator.Validate, trans ut.Translator) error {
	if err := v.RegisterValidation(applicationIDValidatorTag, ValidateApplicationID, false); err != nil {
		return fmt.Errorf("could not register %v validator: %w", applicationIDValidatorTag, err)
	}

	if err := v.RegisterTranslation(applicationIDValidatorTag, trans, registrationFunc(applicationIDValidatorTag, "{0} must be a valid application ID"), translateFunc); err != nil {
		return fmt.Errorf("could not register %v validator error message translation: %w", applicationIDValidatorTag, err)
	}

	return nil
}

func ValidateApplicationID(fl validator.FieldLevel) bool {
	switch fl.Field().String() {
	case "batect":
		return true
	case "test-app":
		return true
	case "smoke-test-app":
		return true
	}

	return false
}

func registrationFunc(tag string, translation string) validator.RegisterTranslationsFunc {
	return func(ut ut.Translator) error {
		if err := ut.Add(tag, translation, false); err != nil {
			return err
		}
		return nil
	}
}

func translateFunc(ut ut.Translator, fe validator.FieldError) string {
	t, err := ut.T(fe.Tag(), fe.Field())

	if err != nil {
		panic(fmt.Sprintf("error translating FieldError: %#v", fe))
	}

	return t
}

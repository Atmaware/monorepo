package app.atmaware.ruminer.core.network

import app.atmaware.ruminer.graphql.generated.CreateLabelMutation
import app.atmaware.ruminer.graphql.generated.SetLabelsMutation
import app.atmaware.ruminer.graphql.generated.type.CreateLabelInput
import app.atmaware.ruminer.graphql.generated.type.SetLabelsInput

suspend fun Networker.updateLabelsForSavedItem(input: SetLabelsInput): List<SetLabelsMutation.Label>? {
    return try {
        val result = authenticatedApolloClient().mutation(SetLabelsMutation(input)).execute()
        result.data?.setLabels?.onSetLabelsSuccess?.labels
    } catch (e: java.lang.Exception) {
        null
    }
}

suspend fun Networker.createNewLabel(input: CreateLabelInput): CreateLabelMutation.Label? {
    return try {
        val result = authenticatedApolloClient().mutation(CreateLabelMutation(input)).execute()
        return result.data?.createLabel?.onCreateLabelSuccess?.label
    } catch (e: java.lang.Exception) {
        null
    }
}

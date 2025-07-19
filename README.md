# cdeeply-unix-bash
UNIX Bash shell interface to C Deeply's neural network generators.  *These scripts require an internet connection!* as the training is done server-side.

*Note*:  these scripts return neural networks embedded in a web page, not as raw data (since they aren't called from within an application).  This web page allows you to run the networks on new data sets, or export the neural network to C/Python/... code.

**Shell scripts:**

`bash cdeeply_regressor [-rows -columns -no-bias -disallow-IO-connections] [-max-weights {N} -max-neurons {N} -max-layers {N} -max-layer-skips {N}] [-I {importances_table_file} -o {output_file}] table_file output_rows/cols`

Generates a x->y prediction network using *supervised* training on `table_file`.
* `table_file` is a numeric table of training samples containing *numInputs+numTargetOutputs* rows or columns.
  * Use the `-rows` option if the target features are table rows, and the `-columns` if they are columns.  `-columns` is the default.
  * The target output rows/columns from `table_file` are specified in the 2nd mandatory argument: comma separated, no spaces (e.g. `5,7`).
* An optional `importances_table_file` weights the cost function of the target outputs.  If passed, it should have *numTargetOutputs* rows/columns.
* Optional parameters `-max-weights`, `-max-neurons` and `-max-layers` limit the size of the neural network (not including input/output neurons), and `-max-weight-depth` limits the depth of layer-to-layer connections.  Set `-disallow-IO-connections` to prevent the input layer from connecting directly to the output layer (so that outliers in new input data won't cause wild outputs).  Use `-max-weights-soft-limit` and `-max-neurons-soft-limit` to relax the tolerances.
* Set `-sparse-weights` to use sparse weight matrices.  This means that a) many of the weights are zero, and b) the weight matrices are stored in a sparse format, i.e. a list of non-zero entries.
* Set `-max-activation-rate` to less than 1 to force sparse neural activations.  This does not work with sigmoid or tanh neurons, as their activtations are never truly zero.  Set `-max-activations-soft-limit` to relax the sparsity limit.
* Use the `-no-bias` option if you don't want to allow a bias (i.e. constant) term in each neuron's input.  Set `-no-negative-weights` to keep all weights positive.
* The `-o` option sets the output HTML filename; the default is `myNN.html`.  This file embeds and runs the neural network.

`bash cdeeply_encoder [-rows -columns -uniform-dist -normal-dist -no-bias] [-no-encoder | -no-decoder] [-max-weights {N} -max-neurons {N} -max-layers {N} -max-layer-skips {N}] [-I {importances_table_file} -o {output_file}] table_file num_features [num_variational_features]`

Generates an autoencoder (or an encoder or decoder) using *unsupervised* training on `table_file`.
* `table_file` is a numeric table of training samples containing *numFeatures* rows or columns.
* `importances_table_file` option is set the same way as for `cdeeply_regressor`.
* Set `-rows` if each feature is a row in `table_file`, and `-columns` if each sample is a column.  `-rows` is the default.
* The size of the encoding is determined by the 2nd mandatory argument `num_features`.
  * So-called variational features are extra randomly-distributed inputs used by the decoder, analogous to the extra degrees of freedom a variational autoencoder generates.  To include these, pass a third non-option argument `num_variational_features`.
  * The `-uniform-dist` option causes the network to assume that variational inputs will be uniformly-(0, 1)-distributed, and the `-normal-dist` option causes it to assume they will normally distributed (zero mean, unit variance).  `-normal-dist` is the default.
* Set `-no-encoder` to generate a decoder-only network.
* Set `-no-decoder` to generate an encoder-only network.
* All other parameters operate the same way as for `cdeeply_regressor`.

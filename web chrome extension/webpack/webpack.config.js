const path = require('path');
const CopyPlugin = require('copy-webpack-plugin');
module.exports = {
    mode: "production",
    entry: {
        awc: path.resolve(__dirname, "..", "src", "awc.ts"),
        background: path.resolve(__dirname, "..", "src", "background.js"),
        content: path.resolve(__dirname, "..", "src", "content.js"),
    },
    devtool: 'inline-source-map',
    output: {
        library: "[name]",
        path: path.join(__dirname, "../dist"),
        filename: "[name].js",
    },
    resolve: {
        extensions: [".ts", ".js"],
    },
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                loader: "ts-loader",
                exclude: /node_modules/,
            },
        ],
    },
    plugins: [
        new CopyPlugin({
            patterns: [{ from: ".", to: ".", context: "public" }]
        }),
    ],
};
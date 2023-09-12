module.exports['without-ext'] = function (title: string) {
    if (title.includes('interfaces/'))
        title = title.replace('interfaces/', '');
    return title.replace('.md', '');
}
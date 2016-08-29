{
    assets:
        body:
            file: 'person.png'
            source_x: 1
            source_y: 1
            width: 16
            height: 16
        head:
            file: 'person.png'
            source_x: 19
            source_y: 1
            width: 10
            height: 10
    animations:
        default:
            width: 16
            height: 21
            frames:
            {
                {
                    assets:
                    {
                        {
                            asset: 'body'
                            x: 0
                            y: 5
                        }
                        {
                            asset: 'head'
                            x: 3
                            y: 0
                        }
                    }
                }
                {
                    assets:
                    {
                        {
                            asset: 'body'
                            x: 0
                            y: 5
                        }
                        {
                            asset: 'head'
                            x: 3
                            y: 2
                        }
                    }
                }
            }
}
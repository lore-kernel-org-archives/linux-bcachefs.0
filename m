Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ePLs+thr"
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9202AE9
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 07:38:42 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-a00c200782dso768829666b.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 07:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1702395521; x=1703000321; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qDZp7gWbuTVE22AvhJgQ9vIXXo9oTgtdlKx+S8j/dsw=;
        b=ePLs+thrYIrckuEll35ovE9pmJp5cwokHTvPGSt9XpSrlwBHAdYY/R2Aa58IidFGwY
         dhfMNhx0XPeLeVDliY50RMI9d9CfMfoOfJMvZcRLjPqSTwO2mLwhQA/WflpZiIFd6soB
         NhFBy50pbUzvBumih5waDU+xa1DM15XnC54gk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702395521; x=1703000321;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qDZp7gWbuTVE22AvhJgQ9vIXXo9oTgtdlKx+S8j/dsw=;
        b=YPxtkTtO90xL229M0k9gjVWE2PZC0ELYGHsgM5MBjUMZKk4roLGput5bp96RV87hQC
         AeXN/ZwgkIFUUUK9N+HbJRkAG/CpeupHExHMmtCNosbe5HAnSsQrlvSa7DtdUceo8wgE
         yc9OqL57ASHNSQ1qYPEszqzs8lRxlFjGiucOxzllPToN9JfynB5h0tRDSmKYeT7jkesA
         ETiVcRx3+Id+XwsD3OnlpRPVzloRtEJv2bxkBpuuU4fzn12RanBXB7/mkhu7DgFG1eP6
         rAybAO1p4T5MjDecZlC5nNoeZJLltnyaQnJ1F00jGs1G/LbpiPKBTwZsTN5+bOR3RBRR
         /+lw==
X-Gm-Message-State: AOJu0Yw1V4fre/gYUn4RaxNJNi+v6XPO2zh22O9e4uoOtM9HbZ1MICHI
	7y9bs9Evxcd8MYkd3jJaNtdvFhKkRRQxyg6fHCcEpw==
X-Google-Smtp-Source: AGHT+IHmZCdgCSlsAh5hzabUbuYuMUlh4UtiP5FO9/RLbX9bRONO0dRdKVOceruL+MQnVZvFpB3AboTApbM1hEUFH3Q=
X-Received: by 2002:a17:906:10c4:b0:a00:185a:a12b with SMTP id
 v4-20020a17090610c400b00a00185aa12bmr1425258ejv.34.1702395521086; Tue, 12 Dec
 2023 07:38:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <170233460764.12910.276163802059260666@noble.neil.brown.name>
 <20231211233231.oiazgkqs7yahruuw@moria.home.lan> <170233878712.12910.112528191448334241@noble.neil.brown.name>
 <20231212000515.4fesfyobdlzjlwra@moria.home.lan> <170234279139.12910.809452786055101337@noble.neil.brown.name>
 <ZXf1WCrw4TPc5y7d@dread.disaster.area> <CAOQ4uxiQcOk1Kw1JX4602vjuWNfL=b_A3uB1FJFaHQbEX6OOMA@mail.gmail.com>
 <20231212-impfung-linden-6f973f2ade19@brauner> <20231212151631.wi7rgawmp3uig6cl@moria.home.lan>
 <20231212-neudefinition-hingucken-785061b73237@brauner> <20231212153542.kl2fbzrabhr6kai5@moria.home.lan>
In-Reply-To: <20231212153542.kl2fbzrabhr6kai5@moria.home.lan>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 12 Dec 2023 16:38:29 +0100
Message-ID: <CAJfpegsKsbdtUHUPnu3huCiPXwX46eKYSUbLXiWqH23GinXo7w@mail.gmail.com>
Subject: Re: file handle in statx (was: Re: How to cope with subvolumes and
 snapshots on muti-user systems?)
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Dave Chinner <david@fromorbit.com>, NeilBrown <neilb@suse.de>, 
	Donald Buczek <buczek@molgen.mpg.de>, linux-bcachefs@vger.kernel.org, 
	Stefan Krueger <stefan.krueger@aei.mpg.de>, David Howells <dhowells@redhat.com>, 
	linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Dec 2023 at 16:35, Kent Overstreet <kent.overstreet@linux.dev> wrote:

> Other poeple have been finding ways to contribute to the technical
> discussion; just calling things "ugly and broken" does not.

Kent, calm down please.  We call things "ugly and broken" all the
time.  That's just an opinion, you are free to argue it, and no need
to take it personally.

Thanks,
Miklos

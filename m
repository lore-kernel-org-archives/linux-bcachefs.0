Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C117031A66
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YlKtirPz"
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192871737
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 07:49:44 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-587b1231dbeso1315761eaf.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 07 Nov 2023 07:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699372183; x=1699976983; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ihspSWvxGcoSuzvtI1XZDTtj47iHLL0djRae31ZrkZo=;
        b=YlKtirPzhnJYxItLYzou277N62WQkjXXLbH2ROO5uUlRwMiotI2Bp5QlYvgtab4Ajx
         lu/4l85jv1IcO55ZM4uzgIEMBRkKaagQWsLve1SoRy4KADyS24TqZDk6Rdhf+2b7t2Rl
         l6ET7rQH7+80aFug8efAfKmA5mqE96d/P8gXK9LzEYx2WLopbDlvad91723tjK23Gy+5
         Bosb1sNDO1IHiugYznBu0SrDtfXBDta3GiDp9KI1VkrElvKma8fDqj/PeMbR9IdLAtUv
         oDfjJUnE+rYqBMCn5XIkAYdonKsOXYekwkHDPJiN7V3ZyWTXcFKU/TAcoiIYuz6Be1tp
         M/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699372183; x=1699976983;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ihspSWvxGcoSuzvtI1XZDTtj47iHLL0djRae31ZrkZo=;
        b=Rwlh94jgIpkTlI/kYEvfTyLd0Xmpb33vpPWpNjPByT8WFeUmZob62ETIwYc/Eg3o0O
         P9m1vl91E/v5QJAhogh0UhMwfLllMM54IRzSoqJ329TFZoMx6eXUN8XjaKp1jtV5uGyL
         A30zL9TkOIlu/XjdI32MCgWAqFWkDl+i9Bm5cn9ZSnp8umjsP9QPdLQtlfhGGnROm1y9
         fQHPbxeQio0jSyTEXV2SNEyObgBnRjrYuUlZE+Atz6o4seuL61jHImFMZBafawLJgKuE
         yawPPiPjsN37s/2jDg9XhrO6yCUBkWikqXYSnfQmJ5sToHriMpKPOP95bHirE4bB0M/x
         4bwg==
X-Gm-Message-State: AOJu0YzoKH0o3CkulPWSURRhI2OTVAaWTjZyNIY80ov+a9no3nDMq0bo
	8cdqG/cGW0JrIYGYYMrswqD91V/GHVYgtnd9fEZWNSco
X-Google-Smtp-Source: AGHT+IFzn4U/f+o+r3cCymC+3OBUT8EZeYGOLj3QpWkXbygL5mGreAvWvhDZb3zB/sR0/PC3UfdN+G8nbgIRyC9BeMs=
X-Received: by 2002:a4a:eace:0:b0:586:b79f:b0ee with SMTP id
 s14-20020a4aeace000000b00586b79fb0eemr31981228ooh.5.1699372183387; Tue, 07
 Nov 2023 07:49:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a8a:158f:0:b0:4f0:1250:dd51 with HTTP; Tue, 7 Nov 2023
 07:49:42 -0800 (PST)
In-Reply-To: <20231107151303.5pbby66icju4ohrq@moria.home.lan>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <20231107151303.5pbby66icju4ohrq@moria.home.lan>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 7 Nov 2023 16:49:42 +0100
Message-ID: <CAGudoHEsb_hGRMeWeXh+UF6po0qQuuq_NKSEo+s1sEb6bDLjpA@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On 11/7/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> On Sun, Nov 05, 2023 at 01:38:49PM +0100, Mateusz Guzik wrote:
>> Setup is a 24 core vm + 24G of ram, running debian 12 with top of
>> master as of writing this e-mail, commit being:
>> commit 1c41041124bd14dd6610da256a3da4e5b74ce6b1 (HEAD -> master,
>> origin/master, origin/HEAD)
>> Merge: b8cc56d0414e 9fd00df05e81
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Sat Nov 4 16:25:36 2023 -1000
>>
>>     Merge tag 'i3c/for-6.7' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/i3c/linux
>>
>> I ran into it when trying to poke around at the fine-grained inode hash
>> patch.
>>
>> Reproduction instructions are here:
>> https://people.freebsd.org/~mjg/fstree.tgz
>
> Alright, there's a two patch series in the bcachefs-testing branch that
> should fix this - it's passing tests in the CI now.
>

I confirm it survives now and finishes in sensible time.

-- 
Mateusz Guzik <mjguzik gmail.com>

Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D9B18AE1
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 19:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KrjwtoPb"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3606e2120bdso65326245ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 11:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705345828; x=1705950628; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o2KivliLlWUkyuljBg4QsuxJKe6QmbQWw2/vp2kVx5w=;
        b=KrjwtoPbBJtCAKj6F55B/V+pvXuz/Xlj9BzUpwnWAHjKWyUmVVz2ifr3bwbDBGT74C
         ftR/+PfS6JvE2qGJOOO+IF8IWdtZl3aAUlezFCd7CGMOl+XTu5VPnErzI3y8Lij8AeOr
         hoiorl6od5qxkOxpAAmO51zhrOLt1H1078kiiTBQBi+pndfOqAj56eAWQ5rTKsIyi16H
         VVR65jl4eCurSvd72RE2PKGUCe+WeHsLIFWopM7a3rLkuQ6vhpiZPBIUQcXLeqxK07hq
         fY6RoX3tDqy5+0LmOPU+FkBVxBN+UGX0b13fG7EfgcytoFibHJwbGk/ARTmudBbXJdpR
         U1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705345828; x=1705950628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2KivliLlWUkyuljBg4QsuxJKe6QmbQWw2/vp2kVx5w=;
        b=q751UDob09nW04TAbvGsMz8A37vxgt16G8CRorTnk43Ml18LtSZe7pHA2bgoDJJzQs
         tSlTwfR30b59nTyRR4RXQT4j0Nn0RrZvo7RvZtUIz1Bw6uoDxpHyr2Qwch+wZTJjRQwj
         CXBbHDEy4bUEA57F0MWEyIWECFU2sN2msAtMRWfWRUq6WGfXua4mqEJ9Hl6U6xlWryTl
         kvbQNAUFoELBOI+DlWseAidBXhb84v4pmSnb6e4zO1AFORyr76sRdH4iYABfBw0hhAxV
         Uc0azEftXWGbxWA8VZblvIFoNsvd8S+mz4+BVYM8QcBBrItoqotIYCXRzUK8iDVV2YBO
         XFsg==
X-Gm-Message-State: AOJu0YyBnJ64ar552pGTFvBa2gmaFW2fc96jtZInkVERMakKwrRNBUBA
	KtXncKYnAgGg1dRWUtEvmSOGJ0k35IFxbA==
X-Google-Smtp-Source: AGHT+IEfC0n4gekVlavgWM77KKRSKrU4CxImeX5WvrZl4/i+gK9mhCpwNuKtPP5aEiLQsDnQK6Z31g==
X-Received: by 2002:a92:de07:0:b0:360:cfba:c136 with SMTP id x7-20020a92de07000000b00360cfbac136mr5604809ilm.109.1705345827650;
        Mon, 15 Jan 2024 11:10:27 -0800 (PST)
Received: from fedora-laptop (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id bd10-20020a056e02300a00b0035f7f712c78sm3056560ilb.36.2024.01.15.11.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 11:10:27 -0800 (PST)
Date: Mon, 15 Jan 2024 12:10:22 -0700
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS 0/2] convert main() from C to Rust
Message-ID: <20240115191022.GC156208@fedora-laptop>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
 <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
 <20240115175509.GA156208@fedora-laptop>
 <iiraqelv6wtwxcdf2yjtjt26ghejngfantjx7d4mztav27qu7y@gmiztxamveq3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iiraqelv6wtwxcdf2yjtjt26ghejngfantjx7d4mztav27qu7y@gmiztxamveq3>

On Mon, Jan 15, 2024 at 01:45:22PM -0500, Kent Overstreet wrote:
> On Mon, Jan 15, 2024 at 10:55:09AM -0700, Thomas Bertschinger wrote:
> > I'm leaning towards keeping Make as the primary build tool for now and
> > perhaps a future patch can move towards using Cargo. But other opinions
> > are welcome.
> 
> Let's hold off on that for now.
> 
> I'm planning on pullling the Rust code in bch_bindgen into the kernel
> soon, and I want to see how that interacts with the kernel build system.
> If there's potential for commonality with the kernel build system, we
> might want to take advantage of that.
> 
> (Also, if you're interested in that project, let me know! Getting that
> ready for the next merge window is a high priority item, but I have a
> lot of high priority items at the moment... :)

Sure, I would definitely be interested in helping out with that. I don't
want to make any promises regarding timeline, since this combines two
worlds--Rust, and Linux Kernel development--that are both still very
new to me. But I can certainly give it an honest try :) as long as you,
or someone else experienced, can help with any questions I might run
into.

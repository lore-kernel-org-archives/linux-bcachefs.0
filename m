Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B59182A0
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BZwvl9uR"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7beefdfe71eso234527039f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 09:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705341314; x=1705946114; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dYC74vm1C/SB+y3RCbgiGDwH9atP7FM9WYzE8+UOEhw=;
        b=BZwvl9uRIIWI7S4Ie0sufjcOSONlspyn1GNQy4wqg6s/Bo6pf6Pur7viZ3xcRIiYUd
         U6DYr1XioVnHJ/Ik6w90dMNSBTzXQT8zg+JqPytNwGjc0mFZifrCjc7sYmiWCFBLD9Fk
         tw7u5AFBshU2gLAT1C64CBZnBwlE5F3DG8t8qoRcE/rFgTgl1WA4+66DkzDIVwTQFAYz
         waFiQot+5l1yYzRttIi3+9rba252abVtZvadYlyAbslsogrldxGo/BpteKnkvCoWhX2t
         oxz1/xJCt+wc55G7aMcSqCTko3KU8yKm3wtekh9fp5//aqXIJXuGje6NlCLdPo07ybrE
         KLBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705341314; x=1705946114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYC74vm1C/SB+y3RCbgiGDwH9atP7FM9WYzE8+UOEhw=;
        b=io5HVfDClBF2yCTlXkADZZEb7WqkCpwdqXxRFDF3Oc+UqtjUNMdIAvMXjmzRrl6JEB
         SbvRtOIsbVi1CAnnKy5WDpiPlghvwMzTz0Ci4mb55gSNiLiygJptatcpTWQ78BdBHpgy
         tNSSf3r70qtQWK9wGz7HJQfEbvPpsQ9bqfIqbWKf4VqzmLs5b0w1IfCsQ1A6Gvppq5g7
         mj5VotQS+2PhWij9zfLWRTC/uTtpHAFtLW5VJnJUn06ByZPV5kiKnnsiuqYmwG3orhUP
         p/1ruGZAApgMSE9xAzsRGpaAPOcpFHb/TZARSLmeHuV5WDeQbwGJyiwi0ZAu0qHpUoDF
         7BIQ==
X-Gm-Message-State: AOJu0YxnM81YMUWfqNYntFWotIJgn1oZjYXbs1cOqKR86beHIrX7UB9g
	5eGPQ/5Ryh3n4ta/tg3fEYrWyfLgAMRkaQ==
X-Google-Smtp-Source: AGHT+IEYb91aBVTOehNCGYpoTzcf9N0UUlL2vsnR+K8CjrLgRXgyhVfgPkE2X2D7NwUqb03mYYpdCg==
X-Received: by 2002:a05:6602:4fd1:b0:7bb:e2ad:de03 with SMTP id gs17-20020a0566024fd100b007bbe2adde03mr5641772iob.25.1705341314354;
        Mon, 15 Jan 2024 09:55:14 -0800 (PST)
Received: from fedora-laptop (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id m6-20020a0566380ac600b0046993034c91sm2478064jab.77.2024.01.15.09.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 09:55:13 -0800 (PST)
Date: Mon, 15 Jan 2024 10:55:09 -0700
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS 0/2] convert main() from C to Rust
Message-ID: <20240115175509.GA156208@fedora-laptop>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
 <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>

On Mon, Jan 15, 2024 at 12:32:23PM -0500, Kent Overstreet wrote:
> I think there's some more rearraging we could do - it'd be cleaner if we
> moved the C sources out of the top level directory, perhaps to c_src,
> and then moved everything in rust-src/ to the toplevel.
> 
> Top level directory is getting a bit crowded, and then the new bcachefs
> binary won't be quite so out of the way; I frequently build and run
> without installing when I'm debugging.

I agree this makes sense. I'll work on a v2 that does this.

Thoughts on keeping Make as the top-level build tool vs. using Cargo? I
am still fairly new to Rust/Cargo so I'm not sure how easy it would be
to replicate all of the Makefile targets in Cargo. It does appear to be
possible to use Cargo to invoke gcc to build the C library.

I can see three approaches:
- keep Make as the primary build tool
- hybrid: use Cargo for source code building but keep the Makefile around
  for the supplemental targets like "make doc", "make rpm", etc.
- use Cargo for everything (not sure if this is easy / possible, but I
  could look into it if desired)

I'm leaning towards keeping Make as the primary build tool for now and
perhaps a future patch can move towards using Cargo. But other opinions
are welcome.

- Thomas Bertschinger

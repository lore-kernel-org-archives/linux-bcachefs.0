Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FE98F4A;
	Sun, 15 Jun 2025 16:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750006003; cv=none; b=gECJhG8qmJYvZ5P6oQF11ABxT4cswOe86whHJRm4oSwqu7ZH5BlOYnkSbtXFy8C9OPIUYy3aufAiIvYrCyq4MhFTO27Rcbovcb8FHbXEDWx3ao8mKV8rYYMPswfZRsw/WrHerZnpi2150XjRtlii6cSW6VUNUVn6/APKB22CRuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750006003; c=relaxed/simple;
	bh=SOWk6TIG82iLlaUhAgD9pKP2ZNabz8ANg/PmP0hCsz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c9jiLRixzIAmNgE/FDH5G7yKihTAvrbVitoBpYxzdWp+IYSj0sMgTvbtMq6jh14LsItv+vKTTJY62bCb7jpTk9+emb+wq+9ya8ZrAbb1rEfj/y3C2Q5Uhp6nuIa5B8ucA+r1R3qqgvpDYyiq6OJVtgsmNHotGrxMVFZwHNN3ll4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DvPodzUt; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvPodzUt"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b2c4331c50eso2852235a12.3;
        Sun, 15 Jun 2025 09:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750005996; x=1750610796; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSY0daWpyZ03oAMbhCydcP6cPAqTJy9hG8mK7fwbpX8=;
        b=DvPodzUtzwcEiKBnZ2zONbiA+Z7lGxZvvR4v+gdzt7AfQinaRKVfPOIfpvxbrltEAb
         FwCEoC/PwyGcnshKomltmvAyXbs/0BaSFUi3/qEa3XopLKeYXmZlr0fflzRFyKVp+oHD
         qpUju76vM416mzWgwV/2IN2MSdDQp9//vHuPQmQRYhDesEcKXsPj8XI0UAgQ2LQKivRX
         BSaypZn90sNs7LPCBK2LAEiPe9tgEZpVIV7Kems4KgFOnEH9eRhH7Ty78tCpfPaWIbJb
         d9cNZ+tCjjxWgGyq588o1plgrTuDzZ/2jZaF8FUwpAeJBpdBwt3hfB7LXPyyD01VGtOT
         sx2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750005996; x=1750610796;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSY0daWpyZ03oAMbhCydcP6cPAqTJy9hG8mK7fwbpX8=;
        b=vKUW1gTHyi7ez0I8DjAAOh7leUsHvkdvP3+wpevZIsuLMLGU6WsAUOKC+2g14lfoKF
         wE1DOwGSfLPWJ1ULVnGNgiF8Umh06YwfmgFZ7BJhIJVLBZPrrz/FNWDRUzKM0KSJVX2F
         kkJwKbZAGG0BE/Yl2FoN5QqAyZF1IQ/Qn4zJ3sBzqZJXRdLdQDE/5CAC/MnnivMDOW6E
         txLLdUjOZ9SsrGuDRsftS73yzlz1N8O5YdBJTKDVWONT6l8p/v86DPEaapQ3rV95thUp
         2MSnhnbs1esQNgJb7sahB0M5k3d4ywBNirzuQtfOBdMUszPOofEsVlzwUdoeDzbrlngm
         laLg==
X-Forwarded-Encrypted: i=1; AJvYcCXBQkHRbmyULbMxuqtSJl1sc55FP/54PhQT2gGPFOhAvlZfUT75XIv8YtIInxnHPggWDu76rXZZQLr6xos=@vger.kernel.org
X-Gm-Message-State: AOJu0YyT0oMtwgxtgB999ECqZL7Se7oI7jvWcsUsM0aEz0PEk4cNtIa8
	xBqqqgOv13IgvO08y4ZpHxXuAovoDyAnXVa9ZccJ7x4dz6M0jLzoyda6m4kqpXKnaJEquaNn7VJ
	dZ0jplOtFcp1j/69bhN9rn4PAnphcgc4=
X-Gm-Gg: ASbGncu7sS6cw1i/oaPbDY4fzqaOs7WXyeJqRvaNSBbqUIVjB1SQICPcgTtBz3QYoLl
	AR6mAYHM+gOS+y61cwM7/1OhjHG4o4ZjnZ/Ghp1mSs79YO7jR3r85own4fNHjMRTUxBkiOWRj37
	anXl5x0om3pPJG5Q6AtgVzIW/cHcWvKQLsJNJtkJKPsbJgUw==
X-Google-Smtp-Source: AGHT+IHmFkN9t/ayfwW/2pRyDteHB4ds9y+n4OojpVIGKCmqVciCOQGygF8jZOaEtov35uzZK/fl8xhGTsPY5KgKxaw=
X-Received: by 2002:a17:90b:3d48:b0:313:f775:d381 with SMTP id
 98e67ed59e1d1-313f775d61amr9021269a91.18.1750005996430; Sun, 15 Jun 2025
 09:46:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250614185743.657564-1-bharadwaj.raju777@gmail.com>
 <bwga4jheevnhuwwpopfwbzsjsxvmte4mtybevkfgssem4zftjo@anj44i6sfyd4>
 <CAPZ5DTEtsqJ_z7OtRVKDqb+LkvS=UfNvCTUqnY2Pu6qGVs+PEQ@mail.gmail.com> <tqzma4qfw7ppu56mqucmekmuhtqs5raos6wrzddf7fjouaeb6g@himxw7j544tb>
In-Reply-To: <tqzma4qfw7ppu56mqucmekmuhtqs5raos6wrzddf7fjouaeb6g@himxw7j544tb>
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Date: Sun, 15 Jun 2025 22:16:09 +0530
X-Gm-Features: AX0GCFsRX6NUr6vHSoY0j6jt3eTCfaK4V36fjjW-QrtFNGcCKr9KidwSRNaQcA8
Message-ID: <CAPZ5DTFoUAfgUwn_nqjTPUDhZ74=reuVZiX0d0fGPt=7LU07UQ@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: don't return early from __btree_err for bad or
 incompatible node read errors
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, shuah@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 15, 2025 at 9:35=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> But then you're calling __bch2_topology_error()? When we're in
> scan_for_btree_nodes we're just checking if the node is readable, we
> shouldn't be doing anything that flags errors/recovery passes elsewhere.

Right, that makes sense. I originally put that in because the old
codepath would unset silent (which was set when in
scan_for_btree_nodes) only if __bch2_topology_error returned nonzero
in the case of bad_node.

> I think the correct fix would be more like
>
> if (scan_for_btree_nodes)
>         return ret =3D=3D -BCH_ERR_btree_node_read_err_fixable
>                 ? bch_err_throw(c, fsck_fix)
>                 : ret; /* or -BCH_ERR_btree_node_read_err_bad_node? */
>

Got it. I'll send the PATCH v2 then, thanks for the guidance!

Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE06326AD0;
	Sun, 15 Jun 2025 08:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749975180; cv=none; b=SlpqmdG7HvUTsLLU3pb37wXkOSKHJinUTCsnn/fCA4M7dvhfLrVXwwQLAiCn6/6CQ3g7QYsaeGkflgd9b6NY4jjz7+BhsIFJfJwc6F4zyqiCv0ByxS4wuWwlXckfaCCwod+kqFJmM5+mbkK/pFXuYlvSZVQicDfh2wuFjDgyo38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749975180; c=relaxed/simple;
	bh=pmdzSLfzz4NJSGkzCeH65VWIRKJh/IdzZWPJQwgCcdk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VclPO9zax/iOQkks7gn9HVytA2+DZjlVob/sW5pXzpx6HZzmL/21UQafft2YeCHPquEcNUdOAOBmhUqAQnsImerE0YM6QpQBg8u41Gq8VU1VXrAfe0l59QLTrEpV5YweMimmPOYP+OpEvbgvN3blwCQZrh9IXl4QDxscitIeTWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GHRvQ19o; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GHRvQ19o"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-311d5fdf1f0so3401898a91.1;
        Sun, 15 Jun 2025 01:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749975178; x=1750579978; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pmdzSLfzz4NJSGkzCeH65VWIRKJh/IdzZWPJQwgCcdk=;
        b=GHRvQ19oQoTiZujBeuL9nks4O1/F+63/vkzRhe9BOLESlM6JQCM2ImRtbkx5dYqUxJ
         MY5eKRaz1tZKvr0/rUcVQ1Ba46KqInk69j0BWLPHm3zPYfDwPITn07qDt6oJ2apmg2Lp
         Fd26zhEtNE9erUQNPCMgwHlsNyDNZOAyOxLbBt4xGJyOduD93n2OtqKFBD7NqnOlgroY
         mOR3aZjFwmRLaPgB1zGTu2QixuQcIS2RHUTdAPr92Wf5JyA6Wm3MX1LThLbW11MtZW7w
         sDXj5I2WY3YKWVsZIymBXmTvyzaYARuVEZWUmJuBG+Fr2rJdjEmAfZBH0aepE4Dd2zLV
         bKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749975178; x=1750579978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pmdzSLfzz4NJSGkzCeH65VWIRKJh/IdzZWPJQwgCcdk=;
        b=goMQhV/o4VfJnxdyO7lFMSj5FlWCCh+lZ0L3hX0QyRswYyU3Xdz69rriQ5g8IvennG
         jrfKCOxEiyqKnd81QjC7HTa7Bi/fGJNxi5E8q5kmyHTpVZGYkLEK6KXeBD5rzxBsU5Pz
         xDlJrkvN8YGhfnil4GAGaGwvj+dJsQEoHZL0YmLL5RWEjGB8mnygH9SJrwhe88VCMldJ
         ocrg7PjJXpMTto3I/6DIZnGu2p37HA7poVBjRNEdyb2t8dw64sFtfQyghgLBCB2GwwcJ
         sv7/fsCUdCKkpwm0Ud8tEprqc43F2uhMPUX3cL94Q2V4fOKkuAiC11dgcLA3Z8EGc3q/
         W/QA==
X-Forwarded-Encrypted: i=1; AJvYcCWQD7WX7AL3WZcd8FPjjMYKBlQeIkx9nyt2H0ujaAJv0veUYSdNtykmNm1vd0IaFDbt8iO/+xpW1Z1NQWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYiOWdnMGzKS4ZGf30aG1V+DwIUjJ5EQfeOqn3g6D7Wxztfl1H
	gECI1uuKhlHJwnAcMIFXaACd3Lst4+n3MAJske7DU1YIMjEbfgZrGx1AKvHtx0967sSBiKUs8r4
	mJhjc2lueZ+MK/x0P80Y0zF1JaRvJbvQ=
X-Gm-Gg: ASbGnct9H/XYenvmOB5+2wIR+BJY1eAlo76S67FSPHfzNELlYPexzw6ycoXHq+vJrYG
	CbjzZsoAwEc5SFMYVqvBPiY7FNq36GLaLxNykZYSrH/oyMBUivjbiV7ZcXpGrODVAy/0pPsoBqp
	7iPKQOx4Dfy2uRiBpKv+aXMJ+PhWOnCplfuUNLPrPngwur
X-Google-Smtp-Source: AGHT+IEsnfJNoeGV0RBNht4K15BTOJBtctaMTJTk0KKCmh27yXWO6d7sAjMAr6HGafs/GiijObboLKEuq0WCnxjZnhg=
X-Received: by 2002:a17:90b:268a:b0:313:283e:e881 with SMTP id
 98e67ed59e1d1-313f1cc5abbmr8371614a91.11.1749975177964; Sun, 15 Jun 2025
 01:12:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250614185743.657564-1-bharadwaj.raju777@gmail.com> <bwga4jheevnhuwwpopfwbzsjsxvmte4mtybevkfgssem4zftjo@anj44i6sfyd4>
In-Reply-To: <bwga4jheevnhuwwpopfwbzsjsxvmte4mtybevkfgssem4zftjo@anj44i6sfyd4>
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Date: Sun, 15 Jun 2025 13:42:22 +0530
X-Gm-Features: AX0GCFuFY-S2D2fUnnHdP_B9uSG3e9P4KroojRUUPxsfHHXiZ0eYnoVubBoBns4
Message-ID: <CAPZ5DTEtsqJ_z7OtRVKDqb+LkvS=UfNvCTUqnY2Pu6qGVs+PEQ@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: don't return early from __btree_err for bad or
 incompatible node read errors
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, shuah@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 15, 2025 at 5:49=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Sun, Jun 15, 2025 at 12:27:40AM +0530, Bharadwaj Raju wrote:
> > After cd3cdb1ef706 ("Single err message for btree node reads"),
> > all errors caused __btree_err to return BCH_ERR_fsck_fix no matter what
> > the actual error type was if the recovery pass was scanning for btree
> > nodes. This lead to the code continuing despite things like bad node
> > formats when they earlier would have caused a jump to fsck_err, because
> > btree_err only jumps when the return from __btree_err does not match
> > fsck_fix. Ultimately this lead to undefined behavior by attempting to
> > unpack a key based on an invalid format.
>
> Hang on, -BCH_ERR_fsck_fix should've caused us to fix fixable errors,
> not cause undefined behaviour.

-BCH_ERR_fsck_fix in btree_err (as _ret from __btree_err) prevents a jump
to fsck_err, so if that is the case, the code afterwards continues
as normal. That's where the UB in this bug comes from.

I think I should explain the path of the bug:
1. bch2_btree_node_read_done calls validate_bset, with a jump to
fsck_err if it returns an error.
2. validate_bset has btree_err_on(bch2_bkey_format_invalid(...), ...),
but in the bug case we were in btree-node-scan so __btree_err returns
fsck_fix, which means ret isn't modified and we don't jump to
fsck_err.
3. validate_bset doesn't return an error code, so
bch2_btree_node_read_done goes ahead and sets the invalid format --
and then UB happens when trying to unpack keys based on it.

> Or is the issue that we're returning -BCH_ERR_fsck_fix for non-fixable
> errors?
>
> Glancing at the code, I think the bug might not be limited to btree node
> scan; we now seem to be passing FSCK_CAN_FIX for all errors in the
> non-btree-node-scan case, and I don't think that's right for
> BCH_ERR_btree_node_read_err_must_retry cases.
>
> But I'll have to go digging through the git history to confirm that, and
> it sounds like you've already looked - does that sound like it?

Isn't the bch2_fsck_err_opt(c, FSCK_CAN_FIX, err_type) call only in
the node_read_err_fixable case?
In the must_retry case we return bad_node. But I'm not really familiar
with all this, so I think it'll be best if you do
take a look.

Thanks!

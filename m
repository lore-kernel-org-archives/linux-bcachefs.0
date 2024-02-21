Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C245380040
	for <linux-bcachefs@vger.kernel.org>; Wed, 21 Feb 2024 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708528010; cv=none; b=W2eETuXMpnYYZrKSgVWfALgEok9i+OKtqXZmbta5GZslnxyjL2VB30LopzOrHN062swQypznOHY7wiFJSdkblpZ4wgvdfNDGerPiTbrOe+SibOyPqyPFyoHmAx/y16neqYXvSbgSsubRzCyNuWKuOp3GhsshLTrIG96zEYoMIiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708528010; c=relaxed/simple;
	bh=IfJatG9lRhZKsYbgCREitFJU8OpCGpoZT8OQPAcVahk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GTUXal+Hlm+BILDb5wq4e5oTXO5GFyJ7ldNZUNQwbVs/1TdHBSiwMcd8ULt0mZpLEKdyw8yU5E5yywuADgAbSrGWriYw97VAbItwZZN5BiFnTvNXmPp550a2NlxDt59mFa9AxZt162j+mQkc8mbmEIQ0BZFJ36cZF3Xc0vWKqXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=cBpNq+AE; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="cBpNq+AE"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a3e82664d53so464848166b.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 21 Feb 2024 07:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1708528006; x=1709132806; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jIv9PGtlgXOsnlHNE4Tcy9JvBcQ7HLVWrvu11qJkS/c=;
        b=cBpNq+AE9Yg4EOhFD+7XEsO7TU5XVOlX8SrcXQIiduRyd9nYXGB7G3uWK4MAOsLM97
         14ek3N7AUgGmTh6xD5kMj9s3JSGsZugvwb7Igy/nVl4dVEBNiPr/lGXzlizXJzh2krUC
         p1K1WPbeAi6qDoq79XdDIXsLf2oc8T7fIhf5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708528006; x=1709132806;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jIv9PGtlgXOsnlHNE4Tcy9JvBcQ7HLVWrvu11qJkS/c=;
        b=Z1JV1ofCwPZhsFl9RxL2GjNQu8asnYGaR9H+LbPLZBi6Qic16+q4CeOw4L9RECyecM
         8XPgh25+scEBSEHRpGuHlWEKpKz5UbiPTeKQnV/+u3O9sBucTeCI3vvU8nGG9HnQ57F2
         VZHLGkg/+YsPua0wG871FjnqUT9q7/qRQivi7Uj0zFt2VVezW5qrMFmJAwfl9Mcy25xl
         JHVJHKng5kbi7/VVsguxdukOOav3pYzB/SskwP0WMqOPaKmiAltHTFScs7adylJtDwwe
         zGa22CECmH2s4TpHSDEM63sOZiliq5XIJHNHVqMuE+OHxbOGxfyARf8QKg919WROuHBS
         1htA==
X-Gm-Message-State: AOJu0YyZYwCnsqdRd/m0ke2WwwwG9miyXvP59JTzRTFfCNa3UZ29yMhw
	aOFT3gapdnJGC4oevan1I5vRYmaQwaoFFAMfexXC8Rh4TlB772FHdH1qglUstydeH25po0HBQe6
	RZWOB7PMCi2+XR5pv1Z/xujyzv5jbQxMvPncQlzZ2qYvUf/zc
X-Google-Smtp-Source: AGHT+IERxnqIikhmylu4cOJ75RfiT2FYUV0rib82c7+t48H2eRYLuPnPyIEpvl+01PQoj6symStM8+Yyyt3FTnnwVaU=
X-Received: by 2002:a17:906:fccd:b0:a3f:816:1e29 with SMTP id
 qx13-20020a170906fccd00b00a3f08161e29mr3428600ejb.39.1708528005923; Wed, 21
 Feb 2024 07:06:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2uvhm6gweyl7iyyp2xpfryvcu2g3padagaeqcbiavjyiis6prl@yjm725bizncq>
In-Reply-To: <2uvhm6gweyl7iyyp2xpfryvcu2g3padagaeqcbiavjyiis6prl@yjm725bizncq>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 21 Feb 2024 16:06:34 +0100
Message-ID: <CAJfpeguBzbhdcknLG4CjFr12_PdGo460FSRONzsYBKmT9uaSMA@mail.gmail.com>
Subject: Re: [LSF TOPIC] statx extensions for subvol/snapshot filesystems & more
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Feb 2024 at 01:51, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Recently we had a pretty long discussion on statx extensions, which
> eventually got a bit offtopic but nevertheless hashed out all the major
> issues.
>
> To summarize:
>  - guaranteeing inode number uniqueness is becoming increasingly
>    infeasible, we need a bit to tell userspace "inode number is not
>    unique, use filehandle instead"

This is a tough one.   POSIX says "The st_ino and st_dev fields taken
together uniquely identify the file within the system."

Adding a bit that says "from now the above POSIX rule is invalid"
doesn't instantly fix all the existing applications that rely on it.

Linux did manage to extend st_ino from 32 to 64 bits, but even in that
case it's not clear how many instances of

    stat(path1, &st);
    unsigned int ino = st.st_ino;
    stat(path2, &st);
    if (ino == st.st_ino)
        ...

are waiting to blow up one fine day.  Of course the code should have
used ino_t, but I think this pattern is not that uncommon.

All in all, I don't think adding a flag to statx is the right answer.
It entitles filesystem developers to be sloppy about st_ino
uniqueness, which is not a good idea.   I think what overlayfs is
doing (see documentation) is generally the right direction.  It makes
various compromises but not to uniqueness, and we haven't had
complaints (fingers crossed).

Nudging userspace developers to use file handles would also be good,
but they should do so unconditionally, not based on a flag that has no
well defined meaning.

Thanks,
Miklos

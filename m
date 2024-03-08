Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725F51DDEA
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Mar 2024 23:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709941049; cv=none; b=PPTl0FS+nFys9hbue18NfZ21T5zEK7pyN3X70grD/ORC5fPoPFA52bAjYN8nn8v8nJzjvkrBZetVr2v9ZL0ifSfa0xFvzjQ5cJLU44KKa0J46mlpUOfxV9KTQFafM/gbGynHXleBdw26Ki2QmdHMGoYFBa8fRB705aEp0hawfIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709941049; c=relaxed/simple;
	bh=IR1evY+/fVJefynOXniLDEGrtFLiPZkwmPmJGfHqqZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X1/cCQEnNgCpqLQwBz2OLgQFrMAtR/wPF5naHv1ilKQ0VtjCw0WGdiPLXxeOpvL5T3c7BD3htu4znoDlLW7Y4s/6tglbcGuru7/CN/QENA30KhvZ9tc5hSzNsMNJrQIrR+gjwaWwYHrYQHjXge2Y8tzOdHzb38fURFcd5gV0AK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=di3eiiua; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="di3eiiua"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d422b6253cso11381331fa.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 08 Mar 2024 15:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1709941045; x=1710545845; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BWqzK++ULFU7/4Kx3s39++fNSG43DjivkrHSKl5PvTo=;
        b=di3eiiuaN3hru8DB84cSnXr0vPEi2u52v8fwY0yVopRYLWSupn+hv+U9XZhAOzzld3
         CWyZW6PhieAB5MZWpi1Pz3Ri01Fh8UZxTAp7ffQnKFxHqy4SnQsamr/AbQjz9IwKTvuq
         dvOO5ybS4OnobVo1AxfoL8wcdMGbch+YqcLbbl/O3jMYXdNCjEKnB9LD8DRY35MNbCXq
         SGZ6LbT6GcOWqP3BrQgcys8YO/8UV0GRPTR+sJc9A1bNOzUMWpK4OaMjeJFnuvgACkdH
         POFqq+LC+iAkLA/ujx64OsO0hevWSVtdW95W+zP3MAjrCQS4CXS1XiCTQSCryvS7OCIH
         oEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709941045; x=1710545845;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BWqzK++ULFU7/4Kx3s39++fNSG43DjivkrHSKl5PvTo=;
        b=Uj+jiAB4pX/vGXytGydsslFpRisTc+emvBuzuifhQZAhAj0QjcWF0+YsypZR2KFybY
         cuowGpL+NTfwO9G51d4VRyBqZ460LKsC7hsgtw8JP7176k2tmiSSkR3dreU3K1NcvLdr
         Sn8QW7nQZ9SpVDFs3aEju1MKEe9beAH8MQ1/uCoXpw9V0dqdvhL9S50QTOfo7KyNiyfY
         CYjD4EhL9VV3SftenBjvGoiBYAG/pEw7b50RN8Zhu+CXb1JwXTzuqNvAUx/YuBQrAt4Y
         Ki+K+nOGKjq3ICgybxXNELAd7w/62ZyLl5Uv/MsTPdvmiauFj+oOZY+70vx3OjY91YOM
         QXNA==
X-Gm-Message-State: AOJu0YwXuTG7zaAs5vxHo6eEh6UGwXvtK9ueXsE1N5tM3Ax/0Ydu5Tu5
	P1GZcDZUBOoLmRHvsPcPCTgHG52JN+OhPbqI0NxYq1wj6gyeijPkLnKjWw53RiB8gKUHNtyTPWr
	ryhBczEIOMrkcub/UqaVDNF2nRiTt8COpZX4=
X-Google-Smtp-Source: AGHT+IFWzZSkB44iR5GtwhVSSKuVPiEPLXHAdxZiOeQ10NWzF3Zugv6ag7i15atvU5VqQC7qRb0dgO4G0yY+86ZiqAo=
X-Received: by 2002:a2e:b0f5:0:b0:2d4:1d45:d5cd with SMTP id
 h21-20020a2eb0f5000000b002d41d45d5cdmr374425ljl.48.1709941045301; Fri, 08 Mar
 2024 15:37:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMU1PDhRCpqsie5G4jOdVsyOmaXa4naDjWFTvjm_RiDrAhwPRw@mail.gmail.com>
 <iloqkrwanqljkorf3tky4rskjqpnl4zqqklejjf3w3gfu3ezjp@uwr2xwhscjlz>
In-Reply-To: <iloqkrwanqljkorf3tky4rskjqpnl4zqqklejjf3w3gfu3ezjp@uwr2xwhscjlz>
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Fri, 8 Mar 2024 23:37:13 +0000
Message-ID: <CAMU1PDjK=j+OfZhs1i7vPwWQ1E4VNx0t0XB-q4xeZ90_imOu1w@mail.gmail.com>
Subject: Re: [WIP] bcachefs fs usage update
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 8 Mar 2024 at 01:23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Wed, Mar 06, 2024 at 11:14:45AM +0000, Mike Fleetwood wrote:
> > On 2024-03-02 04:14, Kent Overstreet wrote:
> > > I'm currently updating the 'bcachefs fs usage' command for the disk
> > > accounting rewrite, and looking for suggestions on any improements we
> > > could make - ways to present the output that would be clearer and more
> > > useful, possibly ideas on on new things to count...
> >
> > [Sorry for any email thread butchering.  I've only just subscribed to
> > the list and seen this in the archive.]
> >
> > Background:
> > I'm working on adding some level of support for bcachefs into GParted.
> > It wants to be able to report the FS usage (per device) of a file system
> > to (1) display in the UI, and (2) to limit how small it allows a
> > partition to be shrunk.  (I understand that bcachefs doesn't currently
> > support shrinking devices).
> >
> > What I would like from bcache fs usage is:
> > 1. To be able to get free and capacity figures for a device in an
> >    unmounted bcachefs file system.
> >    EG:
> >    bcachefs fs usage /dev/$PTN
>
> that'll take some work, but should be doable
>
> > 2. To continue to be able to get free and capacity figures in bytes.
> >    Using a command line switch is okay.
>
> json output?

Json output is not required.  Plain human readable text will do.

None of the other file system tools provide json output so GParted just
parses the plain text output they do provide.  These are the commands
GParted runs and parses the output from to get usage figures for a few
of the file systems it supports:
  btrfs inspect-internal dump-super /dev/$PTN
  dumpe2fs -h /dev/$PTN
  xfs_db -r -c 'sb 0' -c 'print blocksize' -c 'print dblocks' \
  -c 'print fdblocks' /dev/$PTN

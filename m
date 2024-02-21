Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2062183CDF
	for <linux-bcachefs@vger.kernel.org>; Wed, 21 Feb 2024 21:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708549695; cv=none; b=sZW0pDCYOexBsyfH0XQYqNYYUMEwGBT4br88fRz/FQ0dN+LuTRr0zWTRPZyjwQPKfX22NgcFbbpgxRQsI17BJs5M1vxRffzL9Ke90vUUqBfRhFbhmh+6pn+f1/1Q6AkL4pDsfD1MuTg9vqlmszSHbLLEKUVsphMm15NaXb0yGU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708549695; c=relaxed/simple;
	bh=tYBXf2y7UIw2vtxYzTBtooJijhaQRqe+79pKgkHHECI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U96W2MxT/IghniIeN0VdZo83oV3ZclHXfaS8ylEAv16xWu7FWqL5Dkh7x4c4azMd3yyUvmjtoMD2PiQx2nJZO/mWdZg1A7miQxdiWfkxO6DdVOkOhBiMpa9VhqowOOZK7QoSrQCwYXPP3otemzCikVZD9pzzFjZGBVmSPF3UlaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Ib6TAnIH; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Ib6TAnIH"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-dcc7cdb3a98so7392510276.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 21 Feb 2024 13:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1708549693; x=1709154493; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uxQRWE8qWdWGvPbeyoiI7JXSLfPc5rNq4lsxS+F9O60=;
        b=Ib6TAnIHxisbMmR1pdPP/BYKP1SLu/iltfPESg72efh8VTH8O4heJ0FN6Ptm18Wrpl
         sIN1Hw0PRA97PcdRBkW4KuVG2OVcWzyjCQ8MXtBQbxezBH7BbqJ/9hIiexOJHWHXc6hF
         OvdURRvrdp3UBOg4+kx7ou//gYADUBilg41HTNq66jaGqCBh1VQ1myAtjksKV3+cn1vw
         nRAa8ZBAOtzaX6N9oQcXB75wMa3Uca5CMcsYmtYB55bb+wv1O8Vh0kMYmHQm5SvdrxzN
         UMa1ukxvaKArIVeQqtMUn9TfGn/caunRKJn45U9qwty+K4u8n3xu6guyDxC54kkk5Vbe
         4wLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708549693; x=1709154493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uxQRWE8qWdWGvPbeyoiI7JXSLfPc5rNq4lsxS+F9O60=;
        b=F2iimvEciKvP88rjT/kZBXHF+LWmofmQwsGxp2fETLaeUvd3GR7halYS5w7nYBXTMW
         nUtvSWMCEepWq11vDSWHm8Dw7aha+uZPeLecU3DvAuzHHDE6/kLJLPm10xXOg1WaCiLW
         YLXjnjT0pBHm2dSPcOUvCY6Nvwyp9au5mkgZlALyWWHjwej5d0OhhoUZfmuUHKmUJwV7
         0s3x3kyDmB72k9tWRnwvpw4SAun6mYsdz9aDUS6gOz7BWYzv1HEcYAEeDZvFfBZ76Upq
         k8zqCKoz6d5A2H80ScrCd+TzFIAlXzZcgS+SRLETu+XbAdYTnqHwDoSSjCZcygbflSA5
         OxfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl0X7BOGTTzHkc0uhLkY30g5nN38IsLAubfe6VfIKuR/vSynGSv3+oeQsDemquGgUH5BRhCZNxs6HEkoVFGJmmdFoTrI8vx77DBI0zt48=
X-Gm-Message-State: AOJu0Yxekj61///8bXOwS6V0IPuUM1f3Qxh3+yu4P9X+hVdwG8k0/tkT
	9JVymyrA6gtNId8X8cVjwaaVrmWiKBwIvR+tFUsShkCyLq7mVZqfPzRcxpTyFCU=
X-Google-Smtp-Source: AGHT+IHkBQNL8p6Pcm8L+lZPje+lqYlO3FmGWcacKgdbtFyX/CVuuEU6jDOyXLLh/7ci747lQJAMRg==
X-Received: by 2002:a05:6902:1b03:b0:dc7:451b:6e33 with SMTP id eh3-20020a0569021b0300b00dc7451b6e33mr517637ybb.46.1708549692880;
        Wed, 21 Feb 2024 13:08:12 -0800 (PST)
Received: from localhost (076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id i13-20020a25f20d000000b00dcc620f4139sm2483462ybe.14.2024.02.21.13.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Feb 2024 13:08:12 -0800 (PST)
Date: Wed, 21 Feb 2024 16:08:11 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF TOPIC] statx extensions for subvol/snapshot filesystems &
 more
Message-ID: <20240221210811.GA1161565@perftesting>
References: <2uvhm6gweyl7iyyp2xpfryvcu2g3padagaeqcbiavjyiis6prl@yjm725bizncq>
 <CAJfpeguBzbhdcknLG4CjFr12_PdGo460FSRONzsYBKmT9uaSMA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguBzbhdcknLG4CjFr12_PdGo460FSRONzsYBKmT9uaSMA@mail.gmail.com>

On Wed, Feb 21, 2024 at 04:06:34PM +0100, Miklos Szeredi wrote:
> On Wed, 21 Feb 2024 at 01:51, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > Recently we had a pretty long discussion on statx extensions, which
> > eventually got a bit offtopic but nevertheless hashed out all the major
> > issues.
> >
> > To summarize:
> >  - guaranteeing inode number uniqueness is becoming increasingly
> >    infeasible, we need a bit to tell userspace "inode number is not
> >    unique, use filehandle instead"
> 
> This is a tough one.   POSIX says "The st_ino and st_dev fields taken
> together uniquely identify the file within the system."
> 

Which is what btrfs has done forever, and we've gotten yelled at forever for
doing it.  We have a compromise and a way forward, but it's not a widely held
view that changing st_dev to give uniqueness is an acceptable solution.  It may
have been for overlayfs because you guys are already doing something special,
but it's not an option that is afforded the rest of us.

> Adding a bit that says "from now the above POSIX rule is invalid"
> doesn't instantly fix all the existing applications that rely on it.
> 
> Linux did manage to extend st_ino from 32 to 64 bits, but even in that
> case it's not clear how many instances of
> 
>     stat(path1, &st);
>     unsigned int ino = st.st_ino;
>     stat(path2, &st);
>     if (ino == st.st_ino)
>         ...
> 
> are waiting to blow up one fine day.  Of course the code should have
> used ino_t, but I think this pattern is not that uncommon.
> 
> All in all, I don't think adding a flag to statx is the right answer.
> It entitles filesystem developers to be sloppy about st_ino
> uniqueness, which is not a good idea.   I think what overlayfs is
> doing (see documentation) is generally the right direction.  It makes
> various compromises but not to uniqueness, and we haven't had
> complaints (fingers crossed).

Again, you haven't, I have, consistently and constantly for a decade.

> Nudging userspace developers to use file handles would also be good,
> but they should do so unconditionally, not based on a flag that has no
> well defined meaning.

I think that's what we're trying to do, define it properly.  We now have 2 file
systems in tree that have this sort of behavior.  It's not a new or crazy thing
(well I suppose it is when you consider the lifetime of file systems), having a
way for user space developers that care to properly identify they've wandered
across a subvolume boundary could be useful.

As for the proposal itself, we talk about this every year.  We're all more or
less onboard with the idea, the code just needs to be written.  Write the code
and post the patches, I assume that there won't be much pushback, probably could
even get it into Christian's tree in some branch or another before LSF.  Thanks,

Josef

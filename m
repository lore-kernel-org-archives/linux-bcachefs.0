Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E43321A3
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 Aug 2024 18:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723228725; cv=none; b=Nl5Fps4J4l8PH4XhrOokMiKhGgJDaW9T0mDUwnnhFDet/eoM5jZ8s48c3Tf6pemHL1wfqdNXXIG2iKJ3Lhwz8NpcQEpllcb8L9u0MhneDa+awehE1odz1o64qAE5sHeAluqai5kOC1Ohth1sg/1mWoErB9W97nV+OYtjz9x6Jsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723228725; c=relaxed/simple;
	bh=SqPaoMqAV/lzwNv3TXMxlK5QRMuTdQXKpRoCCE6KWhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsPV1FHR2jDNM7bFhyfJRsvAP9HY88QB6vqLHZYPYEJLdzqrmkMewgcyUebbJ818wtHD+812gRYQe6phbjxc5aVlgrLRZxI/eYctzbqCRkLfO/f8y23PaLlSei7b2qdcmj7TdiMlU3MCfXWFbiSWFrmzR+C/Q1yDhS4NlZNqxXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=nx2xh8pt; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="nx2xh8pt"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4ef2006dcdbso873914e0c.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 09 Aug 2024 11:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723228721; x=1723833521; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D/uUx2VRWC0xFbQoxbc5T31lvIjaIYAf3b0g29Y7uEM=;
        b=nx2xh8ptYnc1b71uwb9ICfBkUcwV2GFKpiei1aMyXu/1r7OphaacJY0lCWwmmjM8LN
         +FazHje17U4UVTgCkubiPXSAyzbzqxUPHv2LbzmhQo6ElDJ70cDor74Sx0TTujRkDzwb
         hjiyLSsxds807/tffYt67HtWV3GPsMHVrff2udBs+UE0iTARKh8Zh/n9zsfoYZrQJ5CI
         vEyssnNvZhuHX7nMAT8+Z8pgp4gh4Nr9hCPxU+fAxATlZutjDK9OYn1kWRfo47MdqiB4
         u4UwGIvzMYx25sD621zQdC6qxPASyHOpXGXVEefPPbVI2BCeN1sh75ztTI/CNBZeuSaU
         xa2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723228721; x=1723833521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/uUx2VRWC0xFbQoxbc5T31lvIjaIYAf3b0g29Y7uEM=;
        b=NEAdYmGMWshgpVmzfAKuotIcv7nK9hei9WokOj72gES/ovwz1KpmOGdeHKNWyOe5IG
         6HrIPNPwT80qUVavC4H+wmN2bnKv06o4AtJCPgd9JZX+6KcEmNjv6Bqt+KoLnrCVcm+n
         dX7ozv9BHCVe8+0o18/2XG4rwyqiSnp/3z02UX4dBph2GuttKI6upJdt3g/RBZJwXi9P
         MpTItgY/k3+Z4EKea0Af+RM1/9tg8eU9r6uZog1dMc5XiN5AKJVz3Lkoe4IE9VMStjRN
         048NPPLJO2gI8zp4YYUZcvWDM58exVcERLm6nm+E5VQRwEL5lfaciM/vamWAjSb3ctFN
         QOKg==
X-Forwarded-Encrypted: i=1; AJvYcCXsAffx72oAkEj83VdziIM6LHpS1iF8KxZ4lGuUZ6W5eqefWntsyXUO4EEiCL9mKTcM9bQCVH1WLlB3FMxduR88xc/SJYb6xG4LK8Zd6Dg=
X-Gm-Message-State: AOJu0Yxp6XWns2qOZG1IfdpmzI7kFLGk74wleJelj8lFw5W2yaSsfgaS
	BKnggFP7appWgGsZXjWPRMXC1s6fCP5MViwuyVwwcMct9goMCpJhhfX9CAxBPaU=
X-Google-Smtp-Source: AGHT+IEUgjWxiR6dkM9lZFiJAOmzDsXGGIyhZG7pFpddaDZFMmMnfvsNvFqf3/9xUfjGeq0ImOU3WA==
X-Received: by 2002:a05:6122:181e:b0:4f5:261a:bdc4 with SMTP id 71dfb90a1353d-4f912bc71efmr2958100e0c.2.1723228721244;
        Fri, 09 Aug 2024 11:38:41 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4531c291bc6sm294421cf.96.2024.08.09.11.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:38:40 -0700 (PDT)
Date: Fri, 9 Aug 2024 14:38:39 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Christian Brauner <brauner@kernel.org>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	amir73il@gmail.com, linux-xfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 09/16] fanotify: allow to set errno in FAN_DENY
 permission response
Message-ID: <20240809183839.GB772468@perftesting>
References: <cover.1723144881.git.josef@toxicpanda.com>
 <a28e072cd17de44133b5bce5b8ee6db880523ebb.1723144881.git.josef@toxicpanda.com>
 <20240809-seemeilen-rundum-2096794f9851@brauner>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809-seemeilen-rundum-2096794f9851@brauner>

On Fri, Aug 09, 2024 at 02:06:56PM +0200, Christian Brauner wrote:
> On Thu, Aug 08, 2024 at 03:27:11PM GMT, Josef Bacik wrote:
> > From: Amir Goldstein <amir73il@gmail.com>
> > 
> > With FAN_DENY response, user trying to perform the filesystem operation
> > gets an error with errno set to EPERM.
> > 
> > It is useful for hierarchical storage management (HSM) service to be able
> > to deny access for reasons more diverse than EPERM, for example EAGAIN,
> > if HSM could retry the operation later.
> > 
> > Allow fanotify groups with priority FAN_CLASSS_PRE_CONTENT to responsd
> > to permission events with the response value FAN_DENY_ERRNO(errno),
> > instead of FAN_DENY to return a custom error.
> > 
> > Limit custom error values to errors expected on read(2)/write(2) and
> > open(2) of regular files. This list could be extended in the future.
> > Userspace can test for legitimate values of FAN_DENY_ERRNO(errno) by
> > writing a response to an fanotify group fd with a value of FAN_NOFD in
> > the fd field of the response.
> > 
> > The change in fanotify_response is backward compatible, because errno is
> > written in the high 8 bits of the 32bit response field and old kernels
> > reject respose value with high bits set.
> > 
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/notify/fanotify/fanotify.c      | 18 ++++++++++-----
> >  fs/notify/fanotify/fanotify.h      | 10 +++++++++
> >  fs/notify/fanotify/fanotify_user.c | 36 +++++++++++++++++++++++++-----
> >  include/linux/fanotify.h           |  5 ++++-
> >  include/uapi/linux/fanotify.h      |  7 ++++++
> >  5 files changed, 65 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
> > index 4e8dce39fa8f..1cbf41b34080 100644
> > --- a/fs/notify/fanotify/fanotify.c
> > +++ b/fs/notify/fanotify/fanotify.c
> > @@ -224,7 +224,8 @@ static int fanotify_get_response(struct fsnotify_group *group,
> >  				 struct fanotify_perm_event *event,
> >  				 struct fsnotify_iter_info *iter_info)
> >  {
> > -	int ret;
> > +	int ret, errno;
> > +	u32 decision;
> >  
> >  	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
> >  
> > @@ -257,20 +258,27 @@ static int fanotify_get_response(struct fsnotify_group *group,
> >  		goto out;
> >  	}
> >  
> > +	decision = fanotify_get_response_decision(event->response);
> >  	/* userspace responded, convert to something usable */
> > -	switch (event->response & FANOTIFY_RESPONSE_ACCESS) {
> > +	switch (decision & FANOTIFY_RESPONSE_ACCESS) {
> >  	case FAN_ALLOW:
> >  		ret = 0;
> >  		break;
> >  	case FAN_DENY:
> > +		/* Check custom errno from pre-content events */
> > +		errno = fanotify_get_response_errno(event->response);
> 
> Fwiw, you're fetching from event->response again but have already
> stashed it in @decision earlier. Probably just an oversight.
> 

Decision is the part that has the errno masked off, event->response is the full
mask which will have the errno set in the upper bits, so we have to do the
separate call with event->response to get the errno.  Thanks,

Josef

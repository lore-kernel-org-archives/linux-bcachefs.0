Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855A91BD501
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jul 2024 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722444784; cv=none; b=DMkCxv+9fhXukTNQITLU+fHfVo7gSbdCLviuclFVNKMNIfqZ389290OVpK+hkDmDGfVqexh6VdAWIDboY1Bj7yGlBeZqW4w8mI9uPaGNf0r+bE3rxaT+vlzlrRg6NIyxSBvWU022AjUMNJqDVy6HxErdZKnlpj/fRA9SvoKUIZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722444784; c=relaxed/simple;
	bh=p2sS8yeAfKz1EFKTG0yaZjGwZSGTkLx/gd6yviKg1To=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbKDoZrabnT08sISmHQgeOPOsqls/chD//h2NUeNmt/ecbbVkrbo07OKo6fni9oRVzLTsXh9ju/MBa1JWXtPQN5obq/mzbMnj42i8u8cY9Z1jinXYWsx0E5h1knUqFk2X9thYo3sRTjVK75NBuIqpdfKi9Ng4SJRD179yZQ+yvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MZVvajiU; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MZVvajiU"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3db14cc9066so3715467b6e.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jul 2024 09:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722444780; x=1723049580; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tL+HD2Ty8QZCeLBha1Q7mgorf+VkCmmM0sjUkwiPvkQ=;
        b=MZVvajiUzW4CX6sJ+VyQerBELOIgpiR3dgpz21kVGXur2ylQh0QBWZXInPz9YhKqRU
         Gzm4ScRh4IF7a+cIO20LPkRv7Ecqr/IVJquGdnOrX96LXJVFSC0TCPeYDQIb018cdFqN
         q6G2ri6VqU+bNDxDrMXh5rnv7acTifSQ5OWG/EZUH/c6Ym7gkkRTf38pVvAUeFfjnA8x
         l2zdTn738cAC68wHldbUrUIxyUiZe3Q2otbBlixnqUy3oN+em2MdELJEatCP0APCJl7x
         LFjObHeU/HyYzcf2gpTTVBYvKdFmySXoEQ8VYzPcV+z8KWO6rAedDNQMYz/mT88Og0Pj
         tWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722444780; x=1723049580;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tL+HD2Ty8QZCeLBha1Q7mgorf+VkCmmM0sjUkwiPvkQ=;
        b=YnPSnanya9VX1CyNKx785Y/bGxUrAr8CCEc0qJZM0HdvA6lVK9xycAIkQpjt1j86j7
         euW1h8Q5erb4hz37HBZCV3IjjkFUi0BqcdiGYJ4xMK+kzHjtAMu5uvWtL8wY/DEISAUe
         AoVQ1hDyVHCW72hmUE9AQcyJfBLSsCnwX/d316fIJWDT5zW0mRBJWPU4+Cc7R5lsnQg0
         hsYLjPOls8x3qb1XuQqbNb9dYwnQeJjiidLBWob0UBiZfDi3/99OCffkKW+STZVEfTo5
         StFlM5T/Ai2Lj9kWlg2IPX2gqYiVGTb9Y4COYJJJ+0DS1qkMHrm+Zk5k1BzBXsFxAQPn
         vokw==
X-Forwarded-Encrypted: i=1; AJvYcCVZ1Qg8bYDg2uoX0/09I9TBvbvg2b4KG9rpgAsdjPaLhOb6KA5m/d2NZ7XG6lDv/S3MimwXdeyKefYy30rXAv6w3PMQPfTM7u3YErBnzhI=
X-Gm-Message-State: AOJu0Yx6SSMepNQr2DaC9ALCgWhdRFcdsCh/Mrtk7Kl6TpOr7yyx7h1u
	erAalUd60YsF9eD252Vh7xuM3SwLfFLmMQ8kcyh/vaLykMrmX9kF/5zE9/+L+S8=
X-Google-Smtp-Source: AGHT+IHKBM7a5C9ptGZgwKLnC41lsDOJwwxGZd3BgpTmfrkacVPR3KuytmKPy41jfkQOTPMuaT4IMw==
X-Received: by 2002:a05:6808:d46:b0:3db:1872:f22a with SMTP id 5614622812f47-3db238a73b5mr18885800b6e.23.1722444780524;
        Wed, 31 Jul 2024 09:53:00 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:c572:4680:6997:45a1])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3db418058b7sm746216b6e.24.2024.07.31.09.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 09:53:00 -0700 (PDT)
Date: Wed, 31 Jul 2024 11:52:58 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [bug report] bcachefs: Kill opts.buckets_nouse
Message-ID: <2f4977d6-7f57-468c-af17-bc521b1121e1@suswa.mountain>
References: <31ed13c7-7a14-4693-a9cc-fdb078a3c412@stanley.mountain>
 <x3nici64pxcqqhcngceu2nbtemc64bbirss7fbaeuxk7orjwuc@oxixb5xee5n2>
 <4f8f1e94-2d5f-46e9-8860-af54f522dc94@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f8f1e94-2d5f-46e9-8860-af54f522dc94@wanadoo.fr>

On Wed, Jul 31, 2024 at 06:46:39PM +0200, Christophe JAILLET wrote:
> Le 31/07/2024 à 00:23, Kent Overstreet a écrit :
> > On Tue, Jul 30, 2024 at 02:45:17PM GMT, Dan Carpenter wrote:
> > > Hello Kent Overstreet,
> > > 
> > > Commit ffcbec607613 ("bcachefs: Kill opts.buckets_nouse") from Apr 6,
> > > 2024 (linux-next), leads to the following Smatch static checker
> > > warning:
> > > 
> > > 	fs/bcachefs/super.c:1202 bch2_dev_free()
> > > 	warn: 'ca->buckets_nouse' double freed
> > 
> > yup, that's a bug
> > 
> > -- >8 --
> > Subject: [PATCH] bcachefs: Fix double free of ca->buckets_nouse
> > 
> > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > Fixes: ffcbec6076 ("bcachefs: Kill opts.buckets_nouse")
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > 
> > diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> > index 0542953a7a..6d0ce3d734 100644
> > --- a/fs/bcachefs/super.c
> > +++ b/fs/bcachefs/super.c
> > @@ -1195,7 +1195,6 @@ static void bch2_dev_free(struct bch_dev *ca)
> >   	if (ca->kobj.state_in_sysfs)
> >   		kobject_del(&ca->kobj);
> > -	kfree(ca->buckets_nouse);
> 
> Hi,
> 
> unrelated, but apparently this should also have been kvfree().
> 
> Dan, do you already have a check for such cases where kvfree() or kfree()
> are called when the other one should be used instead?
> 

No.  I don't.  I've been meaning to write one...

KTODO: write a smatch check for calling kfree instead of kvfree()

I'll probably do it in the next week or two.  The min/max changes are
higher priority right now.  :P  #painful

regards,
dan carpenter


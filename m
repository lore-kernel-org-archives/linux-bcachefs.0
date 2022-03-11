Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26264C433F5
	for <linux-bcachefs@archiver.kernel.org>; Fri, 11 Mar 2022 18:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345153AbiCKS6J (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 11 Mar 2022 13:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351025AbiCKS6C (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 11 Mar 2022 13:58:02 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CD010BBE9
        for <linux-bcachefs@vger.kernel.org>; Fri, 11 Mar 2022 10:56:59 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id c4so8110776qtx.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 11 Mar 2022 10:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xQ/Qd9j8o5VSl9EqJOPgQ2OSivqRcGLzevXvT323+Co=;
        b=fsZo1VuIeqTo9LaGd5Ils2ExI0yQWvS2TLRauPl+quwRjfsCxE9hG9YN6S88GX38Jv
         CUdY15AnlCajj1p/lifFIxKdp7dImi4y6773ZRngl3U4NkaalLffLZq6J9GEclsSvh1j
         21WENnIH92YebyUKG9WcG9JoK1YDs00Y9ZGlF+xmz5uEXqtkcb4ebkpYzGId21RYO0By
         ngtHfXXCPfeR4CwAPH+VfzM45CjzQlUx0dg1keG7c5tCZOVHTJKJR8YDTislyabpEA9s
         ufHc5Vi75Vvm8jtn4cCxNIOXuWJNLL6HGeIzAy1qfdSFwJzGsp8k83EMt4QzdponA2+t
         QJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xQ/Qd9j8o5VSl9EqJOPgQ2OSivqRcGLzevXvT323+Co=;
        b=OSlarxRXRH6/t6goQlrcX4mqCpVZKu6Fuq6wllVP2+LUaIwhLHeamtG0uRRIcLN8vy
         N/0kWMxcPvxhGyfgjwoNBsWJID658ZNIJPpPPYMi4mLnhyrrTKKe9pF+G9qXKwHDLlB1
         WtCOE+6+BcpV9msGlLAGHXmTV4GNU43UdL2synKoK0rTvLYcqSkQwwNADYMymv4/c7dI
         j0/JzZHuo6vqh1pyuxDex6QpCuDDiaz7WZyXhkJaEVahpBvto55ZiqYEdsR74Mwt4iMH
         PKZ9ug3c47ilrAh3U0jY/2fAdOuHxN9s5fFoKJSFC8I/TTMnEc3wn3U5Oaick0o6c16T
         9PMg==
X-Gm-Message-State: AOAM530Up8WuC5mk5Fh2H1MP7uO2zMZsWTESaT6i6TIPMVWU81aTFQdd
        X51/as+0B9kr3M6NfjvIBGNLehcHsg==
X-Google-Smtp-Source: ABdhPJzl/DpefJ3fxFNjWXmXf9CM+xWKWuglTm6TuO6srxnlefvMB5PpMfLV0bn4JMAT9FUmVi/Hag==
X-Received: by 2002:a05:622a:24c:b0:2d7:1d1b:c98d with SMTP id c12-20020a05622a024c00b002d71d1bc98dmr9401558qtx.592.1647025018378;
        Fri, 11 Mar 2022 10:56:58 -0800 (PST)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id d21-20020a05622a101500b002e07151139fsm6058582qte.17.2022.03.11.10.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 10:56:57 -0800 (PST)
Date:   Fri, 11 Mar 2022 13:56:55 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Eric Wheeler <bcachefs@lists.ewheeler.net>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs: Kernel panic - not syncing: trans path oveflow
Message-ID: <20220311185655.idsjt7opl5stclu5@moria.home.lan>
References: <6bc8aca6-2f93-4a81-376-13155fcc5d7@ewheeler.net>
 <YilZD2oxhUtFVCfu@moria.home.lan>
 <bc622d24-9fad-7b3-22cb-da4bf2dd32d@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc622d24-9fad-7b3-22cb-da4bf2dd32d@ewheeler.net>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Mar 10, 2022 at 02:25:29PM -0800, Eric Wheeler wrote:
> On Wed, 9 Mar 2022, Kent Overstreet wrote:
> 
> > On Wed, Mar 09, 2022 at 01:14:58PM -0800, Eric Wheeler wrote:
> > > Hi Kent,
> > > 
> > > We just started testing bcachefs snapshots this week: we have a bunch of 
> > > mysql replicas, each in its own subvolume.  Every 4 hours we stop mysql, 
> > > run a subvolume snapshot and restart mysql, so it gets lots of snapshot 
> > > and sync IO from the many database instances.
> > 
> > Cool! Would love to hear any comments you've got so far.
>  
> Happy to.  So far we've hit this bug...but once that is fixed I'm curious 
> how it will compare to btrfs, which has just become too slow...

I think I've got a fix for this up - let me know if it works for you

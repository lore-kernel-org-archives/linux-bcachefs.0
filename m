Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F288CE79D0
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 13:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbjITN3Y (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235050AbjITN3Y (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 20 Sep 2023 09:29:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DCEA9
        for <linux-bcachefs@vger.kernel.org>; Wed, 20 Sep 2023 06:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695216511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kIyNBm+d+ipMolryLMT5aw4AItckTb6fjn11uI8JoCM=;
        b=CF8aF+ufobOPQyQ43a9G/IgnyHkR9faEfHuU1pU3n9P8TgBQ2MpM8MLNaDBw3/IcIf8+d0
        OgiU2Ylroq6aJlAzJcQ6rxqQ7T/YlBBCMwPDIC8oIlmq2d318ukaTja5d3kcpRI+JB/9G5
        Cr0F/1eUTJG9RdEC2Ns+8phezmVqdPk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-sg5cXGkCN7-LBxX-y8fVNA-1; Wed, 20 Sep 2023 09:28:30 -0400
X-MC-Unique: sg5cXGkCN7-LBxX-y8fVNA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-770f43b042eso878201285a.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 20 Sep 2023 06:28:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695216509; x=1695821309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kIyNBm+d+ipMolryLMT5aw4AItckTb6fjn11uI8JoCM=;
        b=tkToZ0FQ1N1jSZ6ZzxVyQbl4sv0KAKix4SjK/cjLbypYRFIi1ftRf5ZYt2J+U7hnu7
         s4GS+pE+9ZJtETYNFyWJBjGnjfor8QQtzHLtJalO7OuSM/kU85O79nZJxvxodZe5rufP
         Bf3kT1uuoC2xwHXhLXRY7p5UaHE5aKmxC0S0eB+5SyWducV6U5/i3dG1oHCYvdeSjWoO
         wKA94s/dkXBevNWML4E1vYXCQ1g+//W7dGKPyuqb34AsmIxH6V4R6hyE9MG8uPwXfBdg
         GxcY4DY28MsNyB3JGW1XMn3ZVpXhX9Ko2c0wENtk9D7L+HVNPM/rum3HmbqihWQtlzNR
         zhZA==
X-Gm-Message-State: AOJu0YyHps8mvqQnlULDCn4x/VRhF//UHXfKrU4czkL/L/5NITSgpG1K
        D6Qgu5bN8HDhJtjJPswvIX0LrmVoCiiDS/toRNNKPZrmtiP7x31Ry0ap/7qAyMQDlw5L9Q3k+Wi
        HwzoLEElOOWvfOIouBjJ7qMoH2Knre8HhDeE=
X-Received: by 2002:a05:620a:4621:b0:76d:aa66:f7b4 with SMTP id br33-20020a05620a462100b0076daa66f7b4mr3045241qkb.11.1695216508928;
        Wed, 20 Sep 2023 06:28:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFr+obosPXBxOAWSOMiaa4c1G8GKuaZtZH0LQe6OiMl53wB04nFwDlzrhkK4WD1jG6eQWKRQ==
X-Received: by 2002:a05:620a:4621:b0:76d:aa66:f7b4 with SMTP id br33-20020a05620a462100b0076daa66f7b4mr3045222qkb.11.1695216508551;
        Wed, 20 Sep 2023 06:28:28 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id cz7-20020a05620a36c700b0076ef3103ba6sm4747167qkb.134.2023.09.20.06.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 06:28:28 -0700 (PDT)
Date:   Wed, 20 Sep 2023 09:28:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] bcachefs: initial freeze/unfreeze support
Message-ID: <ZQrzjG5T2jSthuB9@bfoster>
References: <20230915125154.307450-1-bfoster@redhat.com>
 <20230915125154.307450-5-bfoster@redhat.com>
 <20230920012116.pi7nw5ziebrdffkq@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920012116.pi7nw5ziebrdffkq@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 19, 2023 at 09:21:16PM -0400, Kent Overstreet wrote:
> Pulled this into the testing branch and then got
> 
> https://evilpiepirate.org/~testdashboard/c/de4ea1e2a9ceec5d55fffbc1acab89f0dc8f90b6/xfstests.generic.459/log.br
> 
> So I'll likely kick this patch back out for now, let me know when you
> have a fixed version :)
> 

Ah, sorry.. I should have mentioned this in the cover letter. I'm aware
of this failure but my initial triage has it as an unrelated problem.
That test basically induces I/O errors by explicitly overprovisioning a
dm-thin volume for the fs. The original bug was a livelock issue on XFS
related to metadata writeback failure/retry in this particular scenario.

The test relies on freeze in that it basically consumes all of the
initially provisioned space, issues a freeze in the background (which
will start off hanging because not everything can write back until more
storage is available), and then grows available space so freeze can
proceed to completion. It uses the success/failure of the freeze to
determine pass/failure, and if the freeze fails it looks like it expects
the filesystem to have been remounted ro (which I believe is ext4's way
of dealing with this).

My notes say that freeze failed because the fs shutdown, which I think
is due to the whole overprovision/flush thing leading to I/O errors
(i.e. expected behavior, probably similar to ext4). But TBH I hadn't dug
into it further than initial triage to rule out the core freeze
mechanism itself. I'll dig more into that soon to see whether we need to
change the test or something in the kernel, though I don't think it
necessarily needs to gate freeze support..

Brian


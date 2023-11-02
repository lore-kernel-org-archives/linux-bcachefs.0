Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C15C4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 02:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348236AbjKBCVx (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 22:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348035AbjKBCVx (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 22:21:53 -0400
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDD8BD
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:21:46 -0700 (PDT)
Date:   Wed, 1 Nov 2023 22:21:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698891705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7BW+97PaYW+B1oDU4v0bNDcMFIhYtMlyqJn00l3p6Pk=;
        b=KwPa7Yi4JzqxfDz+UpTPXOY4jdsxYkex30atqQLjdTieyhQNJFKP19QXkvoDvPU+V0y3D4
        2xmWbbmrvd/tVGlp+YXSsfrMDbdpKNTgae53jrXA0+/P0qcXe+RCxcuEPYva5mbqUBSI6+
        4gECOi8DZHU4L8Bmwu9CAFV1IF6tmOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] bcachefs: fix odebug warn and lockdep splat due to
 on-stack rhashtable
Message-ID: <20231102022120.rqtu6pcfzhwe7msx@moria.home.lan>
References: <20231101130102.365223-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101130102.365223-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Nov 01, 2023 at 09:01:02AM -0400, Brian Foster wrote:
> Guenter Roeck reports a lockdep splat and DEBUG_OBJECTS_WORK related
> warning when bch2_copygc_thread() initializes its rhashtable. The
> lockdep splat relates to a warning print caused by the fact that the
> rhashtable exists on the stack but is not annotated as so. This is
> something that could be addressed by INIT_WORK_ONSTACK(), but
> rhashtable doesn't expose that control and probably isnt worth the
> churn for just one user. Instead, dynamically allocate the
> buckets_in_flight structure and avoid the splat that way.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Thanks, applied

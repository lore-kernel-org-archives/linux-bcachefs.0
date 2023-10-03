Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A27E7AD46
	for <linux-bcachefs@archiver.kernel.org>; Tue,  3 Oct 2023 13:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbjJCN2J (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 3 Oct 2023 09:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbjJCN2I (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 3 Oct 2023 09:28:08 -0400
Received: from out-195.mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AF9D3
        for <linux-bcachefs@vger.kernel.org>; Tue,  3 Oct 2023 06:28:04 -0700 (PDT)
Date:   Tue, 3 Oct 2023 09:27:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696339682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2y99uhSU3WpoFMIg+wbc3gCYqBiPyHro0o55Qa3UnWc=;
        b=AGYVpbXcGCWBKTwBX6dVtk5jwQVc4w+bmO3nbwnqS5aKI6VdKmUDmhJffxANSDC8JRpOIa
        FeAtQ0l1yVeZ1+m1RR3eRXolCm4e1TB9O7wt4dtX1SWi3ygtpHUTRCaAsUFUIyUuVPqwAs
        4W7riUzi5AL99wgmWwln7fUBJIKjjmc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Brian Foster <bfoster@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 df964ce9ef9fea10cf131bf6bad8658fde7956f6
Message-ID: <20231003132758.uioastp5lxnitwxz@moria.home.lan>
References: <202309301308.d22sJdaF-lkp@intel.com>
 <202309301403.82201B0A@keescook>
 <20231002032239.t7ghpigbq5jy3ng7@moria.home.lan>
 <202310012150.72AAB06FAD@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202310012150.72AAB06FAD@keescook>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Oct 01, 2023 at 09:52:22PM -0700, Kees Cook wrote:
> On Sun, Oct 01, 2023 at 11:22:39PM -0400, Kent Overstreet wrote:
> > I'm not leaping at the chance to reorganize my fundamental data
> > structures for this.
> 
> Yeah, understood. Thanks for taking a look at it!
> 
> > Can we get such an escape hatch?
> 
> Sure, please use unsafe_memcpy(), and include a comment on how the sizing
> has been bounds checked, etc.

Thanks, I knew there had to be one :)

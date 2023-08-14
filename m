Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B92CC41513
	for <linux-bcachefs@archiver.kernel.org>; Mon, 14 Aug 2023 07:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbjHNH0e (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 14 Aug 2023 03:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbjHNH0C (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 14 Aug 2023 03:26:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92EEE71;
        Mon, 14 Aug 2023 00:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 574AB60FC0;
        Mon, 14 Aug 2023 07:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1267C433C7;
        Mon, 14 Aug 2023 07:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691997960;
        bh=1A9YEnUcu7Eg2vK7JVAjQdZ1UkRIoScgTTuUqnG2Hgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=msm1TBeBHOOkLoyyh0+znDPBUiBWqSjLhBgX2W3Pb7dlsqEJ0QeFmyoksmOEspCZ5
         Wq+78v0I52y/i5+RLgQtdgCRZzV6rXL68VOJlfeAGgtuyGjKiz9jTetsKeaSIl0fUz
         +EYrI7nEJPBJsGth04mzuBR9emf3qpsie1k3bsrSnpgHd8ap0FK+FXrVdmeAUVub6x
         i9A5Bt8H/0VR21BJ6mE+nSW19ipKnf3vZKtHapACCz6x5EyRowCYtxvylo6/tYFdts
         JvDAp3uHbq060Be3bQQU6PEmfSfKFtDVmeZBUwy42GNRbE/mrepWvkLAaAakUsBDP+
         DgNnbtCc6DCCg==
Date:   Mon, 14 Aug 2023 09:25:54 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org, djwong@kernel.org,
        dchinner@redhat.com, sandeen@redhat.com, willy@infradead.org,
        josef@toxicpanda.com, tytso@mit.edu, bfoster@redhat.com,
        jack@suse.cz, andreas.gruenbacher@gmail.com, peterz@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, snitzer@kernel.org,
        axboe@kernel.dk
Subject: Re: [GIT PULL] bcachefs
Message-ID: <20230814-funknetz-dreikampf-196dd2545dd9@brauner>
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
 <20230706155602.mnhsylo3pnief2of@moria.home.lan>
 <20230712025459.dbzcjtkb4zem4pdn@moria.home.lan>
 <CAHk-=whaFz0uyBB79qcEh-7q=wUOAbGHaMPofJfxGqguiKzFyQ@mail.gmail.com>
 <20230810155453.6xz2k7f632jypqyz@moria.home.lan>
 <20230811-neigt-baufinanzierung-4c9521b036c6@brauner>
 <20230811125801.g3uwnouefoleq4nx@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230811125801.g3uwnouefoleq4nx@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Aug 11, 2023 at 08:58:01AM -0400, Kent Overstreet wrote:
> I don't see the justification for the delay - every cycle there's some
> amount of vfs/block layer refactoring that affects filesystems, the
> super work is no different.

So, the reason is that we're very close to having the super code
massaged in a shape where bcachefs should be able to directly make use
of the helpers instead of having to pull in custom code at all. But not
all that work has made it.

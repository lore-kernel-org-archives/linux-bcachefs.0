Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3A7C77B7A
	for <linux-bcachefs@archiver.kernel.org>; Wed, 24 May 2023 06:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239532AbjEXGqF (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 24 May 2023 02:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239556AbjEXGp2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 24 May 2023 02:45:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834A21FD5;
        Tue, 23 May 2023 23:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1YHPZN3caSUAM4s/Pvh7BtKj8hUE0NEksfjFZHEKbEQ=; b=BSb4j1iOUzfG/ITB7TfBTVqgGg
        es971crQyo4u3PD7a7C9OZv/avVCkEH7PPd8QVShoAy1lUnFhFvVoTsuD6xcgYp4Z+z7f48VIb74Z
        PCcEPSYaV3bpkEdN8C/abaMn1hleQfTLkmO5VYN5nSxr2EHtUWXIDcQZZVTtxYRyCTgdH83iiXcNB
        mb0BsvIf2c2yKldEMISiOmWJRFDj8JwguKO3HjVantLj1bbLNF1tygXi+f8dDxVCD+gMWzq/0p/SD
        pkJa84QXmbpeXPA708c1th9d1QAMWwOjgoHSoy0KN8IqA3G2MiFcT+/TdgGcpOvRddQUcIw6cZ4DZ
        DeF7VWfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q1iE7-00CWQ9-0N;
        Wed, 24 May 2023 06:44:03 +0000
Date:   Tue, 23 May 2023 23:44:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: (subset) [PATCH 20/32] vfs: factor out inode hash head
 calculation
Message-ID: <ZG2yM1vzHZkW0yIA@infradead.org>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-21-kent.overstreet@linux.dev>
 <20230523-plakat-kleeblatt-007077ebabb6@brauner>
 <ZG1D4gvpkFjZVMcL@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG1D4gvpkFjZVMcL@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, May 24, 2023 at 08:53:22AM +1000, Dave Chinner wrote:
> Hi Christian - I suspect you should pull the latest version of these
> patches from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git vfs-scale
> 
> The commit messages are more recent and complete, and I've been
> testing the branch in all my test kernels since 6.4-rc1 without
> issues.

Can you please send the series to linux-fsdevel for review?

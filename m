Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85BAEB64D7
	for <linux-bcachefs@archiver.kernel.org>; Tue, 20 Jun 2023 20:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjFTUnK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 20 Jun 2023 16:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjFTUnJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 20 Jun 2023 16:43:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7B7EA
        for <linux-bcachefs@vger.kernel.org>; Tue, 20 Jun 2023 13:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA01E611C8
        for <linux-bcachefs@vger.kernel.org>; Tue, 20 Jun 2023 20:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D20C433CA;
        Tue, 20 Jun 2023 20:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687293787;
        bh=+GKm7AfWZk7imJmF+l1VZpt2mG2VQKVZcNY+CGDuwQk=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=Ze45L8Tvl9JFRVnMoGAzuTAAfQfxp3JkU9Eip0mvn+HFpj63t6plWQ9FiWP6ByhP6
         qUK2977tv7T4S/PeC1C3OI0JBLGteL1tA3iYmItKuYW+I71iRIpjBZVzIEA9pGlVV+
         kaQbdwzf91S93BSuxVLp7BtrnqWASs898jC2XXadwFDYAqagGz37DQbmKFQYUIk23u
         hXArqOY5gcpzmr7gjX53SjIAyCqEovqOQZmEFefKsoP7gkftnXFtJ7+nT61LesSgD7
         FYTBUlkAqtpX6dFTuvlwfNB8Knms9OWNth0HprmHxqJJ+MR8iY5TSC9soKW/wpzYc3
         OIqhrjp23nunw==
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 60AC127C0054;
        Tue, 20 Jun 2023 16:43:05 -0400 (EDT)
Received: from imap48 ([10.202.2.98])
  by compute3.internal (MEProxy); Tue, 20 Jun 2023 16:43:05 -0400
X-ME-Sender: <xms:WA-SZGIhlkCOy4gJ05bXlAwIyHMyG6h6dZBbsW56dmjvo3I-Klmx4A>
    <xme:WA-SZOJeOGyLHCr316h2GtjCbhc9G0tPYuBx5MeWj8HTx0FPEEGw6QHMvy8CD25eB
    -V6IOv8y2fPydZB6KY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeefhedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    nhguhicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpedvveelvdeukedtuefhgeevvdeluefgteeggffggfegteehhfek
    tdffkeeiffetjeenucffohhmrghinhepghhouggsohhlthdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhguhidomhgvshhmthhp
    rghuthhhphgvrhhsohhnrghlihhthidqudduiedukeehieefvddqvdeifeduieeitdekqd
    hluhhtoheppehkvghrnhgvlhdrohhrgheslhhinhhugidrlhhuthhordhush
X-ME-Proxy: <xmx:WA-SZGvK9ySKVoi3jwBBUEc5kH9CTW0utMrAW0_UcVNuC6fN_tqQUQ>
    <xmx:WA-SZLa95AYXehTeVVIPWBLvjDcrEGNk4ZEeDm0LtQv92yjVW4jVBA>
    <xmx:WA-SZNYO4mWVXiRPj-BtpvQXSs0KZmPDhuW2ApRxLzqKjuco_kylFA>
    <xmx:WQ-SZKQC4it0RRJaIkIEPbk0Bm7JgNMDm-ifYGmX0uMe1ZVHh-_kdQ>
Feedback-ID: ieff94742:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id D107931A0064; Tue, 20 Jun 2023 16:43:04 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-499-gf27bbf33e2-fm-20230619.001-gf27bbf33
Mime-Version: 1.0
Message-Id: <ff2006db-cd13-48c4-bc5b-1864f9ec9149@app.fastmail.com>
In-Reply-To: <37d2378e-72de-e474-5e25-656b691384ba@intel.com>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-8-kent.overstreet@linux.dev>
 <ZJAdhBIvwFBOFQU/@FVFF77S0Q05N>
 <20230619104717.3jvy77y3quou46u3@moria.home.lan>
 <ZJBOVsFraksigfRF@FVFF77S0Q05N.cambridge.arm.com>
 <20230619191740.2qmlza3inwycljih@moria.home.lan>
 <5ef2246b-9fe5-4206-acf0-0ce1f4469e6c@app.fastmail.com>
 <20230620180839.oodfav5cz234pph7@moria.home.lan>
 <dcf8648b-c367-47a5-a2b6-94fb07a68904@app.fastmail.com>
 <37d2378e-72de-e474-5e25-656b691384ba@intel.com>
Date:   Tue, 20 Jun 2023 13:42:44 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Dave Hansen" <dave.hansen@intel.com>,
        "Kent Overstreet" <kent.overstreet@linux.dev>
Cc:     "Mark Rutland" <mark.rutland@arm.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
        "Kent Overstreet" <kent.overstreet@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Uladzislau Rezki" <urezki@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>, linux-mm@kvack.org,
        "Kees Cook" <keescook@chromium.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Subject: Re: [PATCH 07/32] mm: Bring back vmalloc_exec
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all-

On Tue, Jun 20, 2023, at 11:48 AM, Dave Hansen wrote:
>>> No, I'm saying your concerns are baseless and too vague to
>>> address.
>> If you don't address them, the NAK will stand forever, or at least
>> until a different group of people take over x86 maintainership.
>> That's fine with me.
>
> I've got a specific concern: I don't see vmalloc_exec() used in this
> series anywhere.  I also don't see any of the actual assembly that's
> being generated, or the glue code that's calling into the generated
> assembly.
>
> I grepped around a bit in your git trees, but I also couldn't find it in
> there.  Any chance you could help a guy out and point us to some of the
> specifics of this new, tiny JIT?
>

So I had a nice discussion with Kent on IRC, and, for the benefit of everyone else reading along, I *think* the JITted code can be replaced by a table-driven approach like this:

typedef unsigned int u32;
typedef unsigned long u64;

struct uncompressed
{
    u32 a;
    u32 b;
    u64 c;
    u64 d;
    u64 e;
    u64 f;
};

struct bitblock
{
    u64 source;
    u64 target;
    u64 mask;
    int shift;
};

// out needs to be zeroed first
void unpack(struct uncompressed *out, const u64 *in, const struct bitblock *blocks, int nblocks)
{
    u64 *out_as_words = (u64*)out;
    for (int i = 0; i < nblocks; i++) {
        const struct bitblock *b;
        out_as_words[b->target] |= (in[b->source] & b->mask) << b->shift;
    }
}

void apply_offsets(struct uncompressed *out, const struct uncompressed *offsets)
{
    out->a += offsets->a;
    out->b += offsets->b;
    out->c += offsets->c;
    out->d += offsets->d;
    out->e += offsets->e;
    out->f += offsets->f;
}

Which generates nice code: https://godbolt.org/z/3fEq37hf5

It would need spectre protection in two places, I think, because it's almost most certainly a great gadget if the attacker can speculatively control the 'blocks' table.  This could be mitigated (I think) by hardcoding nblocks as 12 and by masking b->target.

In contrast, the JIT approach needs a retpoline on each call, which could be more expensive than my entire function :)  I haven't benchmarked them lately.

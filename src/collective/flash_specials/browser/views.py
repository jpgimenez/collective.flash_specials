# -*- coding: utf-8 -*-
from zope.i18nmessageid import MessageFactory
from five import grok
from plone.dexterity.content import Item


_ = MessageFactory('collective.flash_specials')


class FlashSpecialView(grok.View):
    grok.context(Item)
    grok.require('zope2.View')
